import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/reset_password_controller.dart';
import 'package:task_manager/ui/screen/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.mailContainer, required this.otp});

  final String mailContainer;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ResetPasswordController _resetPasswordController =
      Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 82,
                  ),
                  Text(
                    'Set Password',
                    style: textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Minimum Number of Password Should be 8 letters',
                    style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildResetPasswordForm(),
                  const SizedBox(height: 24),
                  Center(
                    child: _buildHaveAccountSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Method Extraction
  Widget _buildResetPasswordForm() {
    return Column(
      children: [
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'New Password',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _newPasswordTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter new Password';
              }
              if (value!.length <= 8) {
                return 'Enter a password more than 8 character';
              }
              return null;
            }),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Confirm Password',
          ),
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return 'Confirm your password';
            }
            return null;
          },
          controller: _confirmPasswordTEController,
        ),
        const SizedBox(height: 48),
        GetBuilder<ResetPasswordController>(builder: (controller) {
          return Visibility(
            visible: !controller.inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5),
          text: "Have an account? ",
          children: [
            TextSpan(
                text: 'Sign In',
                style: const TextStyle(
                  color: AppColors.themeColor,
                ),
                recognizer: TapGestureRecognizer()..onTap = _onTapSignIn),
          ]),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordTEController.text == _confirmPasswordTEController.text) {
        _resetPassword();
      } else {
        showSnackBarMessage(
            context, 'New Password and Confirm Password Not Match', true);
      }
    }
  }

  Future<void> _resetPassword() async {
    final bool result = await _resetPasswordController.resetPassword(
        widget.mailContainer, widget.otp, _newPasswordTEController.text);

    if (result) {
      showSnackBarMessage(context, 'OTP verified successfully');
      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(SignInScreen.name);
    } else {
      showSnackBarMessage(
          context, _resetPasswordController.errorMessage!, true);
    }
  }

  void _onTapSignIn() {
    Get.offAllNamed(SignInScreen.name);
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
