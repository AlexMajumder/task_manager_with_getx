import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/change_status_controller.dart';
import 'package:task_manager/ui/controller/delete_status_controller.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.onRefreshList,
  });

  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';
  final ChangeStatusController _changeStatusController =
      Get.find<ChangeStatusController>();
  final DeleteStatusController _deleteStatusController =
      Get.find<DeleteStatusController>();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.title ?? '',
                style: Theme.of(context).textTheme.titleSmall),
            Text(
              widget.taskModel.description ?? '',
            ),
            Text(
              'Date: ${widget.taskModel.createdDate ?? ""}',
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTaskStatusChip(),
                Wrap(
                  children: [
                    GetBuilder<ChangeStatusController>(builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenterCircularProgressIndicator(),
                        child: IconButton(
                          onPressed: _onTapEditButton,
                          icon: const Icon(Icons.edit),
                        ),
                      );
                    }),
                    GetBuilder<DeleteStatusController>(builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenterCircularProgressIndicator(),
                        child: IconButton(
                          onPressed: _onTapDeleteButton,
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['New', 'Completed', 'Cancelled', 'Progress'].map((e) {
                return ListTile(
                  onTap: () {
                    _changeStatus(e);
                    Navigator.pop(context);
                  },
                  title: Text(e),
                  selected: _selectedStatus == e,
                  trailing:
                      _selectedStatus == e ? const Icon(Icons.check) : null,
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel')),
              TextButton(onPressed: () {}, child: const Text('okay'))
            ],
          );
        });
  }

  Widget buildTaskStatusChip() {
    return Chip(
      label: Text(
        widget.taskModel.status!,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: const BorderSide(color: AppColors.themeColor),
    );
  }

  Future<void> _changeStatus(String newStatus) async {
    final bool result = await _changeStatusController.changeStatus(
        widget.taskModel.sId!, newStatus);

    if (result) {
      widget.onRefreshList();
    } else {
      showSnackBarMessage(context, _changeStatusController.errorMessage!, true);
    }
  }

  Future<void> _onTapDeleteButton() async {
    final bool result =
        await _deleteStatusController.deleteStatus(widget.taskModel.sId!);
    if (result) {
      widget.onRefreshList();
    } else {
      showSnackBarMessage(context, _deleteStatusController.errorMessage!, true);
    }
  }
}
