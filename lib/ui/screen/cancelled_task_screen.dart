import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/cancelled_task_list_controller.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTaskListController _cancelledTaskListController =
      Get.find<CancelledTaskListController>();

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CancelledTaskListController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CenterCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: () async {
            _getCancelledTaskList();
          },
          child: ListView.separated(
            itemCount: _cancelledTaskListController.taskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _cancelledTaskListController.taskList[index],
                onRefreshList: () {
                  _getCancelledTaskList();
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

  Future<void> _getCancelledTaskList() async {
    final bool result =
        await _cancelledTaskListController.getCancelledTaskList();

    if (result == false) {
      showSnackBarMessage(
        context,
        _cancelledTaskListController.errorMessage!,
        true,
      );
    }
  }
}
