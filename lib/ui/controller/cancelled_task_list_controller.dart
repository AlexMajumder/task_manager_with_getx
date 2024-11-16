import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelledTaskListController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  List<TaskModel> _taskList = [];

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  List<TaskModel> get taskList => _taskList;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.cancelledTaskList,
    );
    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}
