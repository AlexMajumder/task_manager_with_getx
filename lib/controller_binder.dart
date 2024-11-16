import 'package:get/get.dart';
import 'package:task_manager/ui/controller/add_new_task_controller.dart';
import 'package:task_manager/ui/controller/cancelled_task_list_controller.dart';
import 'package:task_manager/ui/controller/change_status_controller.dart';
import 'package:task_manager/ui/controller/conpleted_task_controller.dart';
import 'package:task_manager/ui/controller/delete_status_controller.dart';
import 'package:task_manager/ui/controller/forgot_password_email_controller.dart';
import 'package:task_manager/ui/controller/forgot_password_otp_controller.dart';
import 'package:task_manager/ui/controller/new_task_list_controller.dart';
import 'package:task_manager/ui/controller/progress_task_list_controller.dart';
import 'package:task_manager/ui/controller/reset_password_controller.dart';
import 'package:task_manager/ui/controller/sign_in_controller.dart';
import 'package:task_manager/ui/controller/task_status_count_controller.dart';
import 'package:task_manager/ui/controller/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(TaskStatusCountController());
    Get.put(CancelledTaskListController());
    Get.put(CompletedTaskController());
    Get.put(ProgressTaskListController());
    Get.put(AddNewTaskController());
    Get.put(UpdateProfileController());
    Get.put(ChangeStatusController());
    Get.put(DeleteStatusController());
    Get.put(ForgotPasswordEmailController());
    Get.put(ForgotPasswordOtpController());
    Get.put(ResetPasswordController());
  }

}