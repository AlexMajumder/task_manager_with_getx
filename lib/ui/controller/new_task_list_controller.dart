import 'package:get/get.dart';
import 'package:task_manager/data/models/task_model.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListController extends GetxController{

  bool _inProgrss = false;

  String? _errorMessage;

  List<TaskModel> _taskList = [];

  bool get inProgress => _inProgrss;

  String? get errorMessage => _errorMessage;


  List<TaskModel> get taskList => _taskList;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _inProgrss = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.newTaskList,
    );
    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgrss = false;
    update();

    return isSuccess;
  }


}