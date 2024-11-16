import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/conpleted_task_controller.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController _completedTaskController =
      Get.find<CompletedTaskController>();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompletedTaskController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CenterCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: () async {
            _getCompletedTaskList();
          },
          child: ListView.separated(
            itemCount: _completedTaskController.taskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _completedTaskController.taskList[index],
                onRefreshList: _getCompletedTaskList,
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

  Future<void> _getCompletedTaskList() async {
    final bool result = await _completedTaskController.completedTaskList();

    if (result == false) {
      showSnackBarMessage(
        context,
        _completedTaskController.errorMessage!,
        true,
      );
    }
  }
}
