import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/models/task_status_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskStatusCountController extends GetxController{

  bool _inProgress = false;
  String? _errorMessage;
  List<TaskStatusModel> _taskStatusCountList = [];

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  List<TaskStatusModel> get taskStatusCountList => _taskStatusCountList;

  Future<bool> getTaskStatusCountList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskStatusCount,
    );
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;

  }



}