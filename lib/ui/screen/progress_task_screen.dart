import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/progress_task_list_controller.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTaskListController _progressTaskListController =
      Get.find<ProgressTaskListController>();

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressTaskListController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CenterCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: () async {
            _getProgressTaskList();
          },
          child: ListView.separated(
            itemCount: _progressTaskListController.taskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _progressTaskListController.taskList[index],
                onRefreshList: () {
                  _getProgressTaskList();
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          ),
        ),
      );
    });
  }

  Future<void> _getProgressTaskList() async {
    final bool result = await _progressTaskListController.progressTaskList();

    if (result == false) {
      showSnackBarMessage(
        context,
        _progressTaskListController.errorMessage!,
        true,
      );
    }
  }
}
