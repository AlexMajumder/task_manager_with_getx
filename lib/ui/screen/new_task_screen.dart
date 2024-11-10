import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/new_task_list_controller.dart';
import 'package:task_manager/ui/screen/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summery_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getTaskStatusCountListInProgress = false;
  List<TaskStatusModel> _taskStatusCountList = [];

  final NewTaskListController _newTaskListController = Get.find<NewTaskListController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            buildSummerySection(),
            Expanded(
              child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inProgress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: ListView.separated(
                      itemCount: controller.taskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(taskModel: controller.taskList[index],
                          onRefreshList: _getNewTaskList,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddFAB,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildSummerySection() {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: _getTaskStatusCountListInProgress == false,
        replacement: const CenterCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummeryCardList(),
          ),
        ),
      ),
    );
  }

  List<TaskSummeryCard> _getTaskSummeryCardList(){
    List<TaskSummeryCard> taskSummeryCardList =[];
    for(TaskStatusModel t in _taskStatusCountList){
      taskSummeryCardList.add(TaskSummeryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummeryCardList;
  }

  void _onTapAddFAB() async{
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if(shouldRefresh == true){
      _getNewTaskList();
    }
  }

  Future<void> _getNewTaskList() async {
    final bool result = await _newTaskListController.getNewTaskList();

    if (result == false) {
      showSnackBarMessage(context, _newTaskListController.errorMessage!,true,);
    }
  }

  Future<void> _getTaskStatusCount() async {
    _taskStatusCountList.clear();// for avoid Append the list
    _getTaskStatusCountListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskStatusCount,
    );
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage,true,);
    }
    _getTaskStatusCountListInProgress = false;
    setState(() {});
  }

}
