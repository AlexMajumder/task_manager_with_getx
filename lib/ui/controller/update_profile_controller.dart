import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(String email, String firstName, String lastName,
      String mobile, String? password, XFile? image) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password != null) {
      requestBody["password"] = password;
    }

    if (image != null) {
      List<int> imageByte = await image.readAsBytes();
      String convertedImage = base64Encode(imageByte);
      requestBody["photo"] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}
