import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/ui/screen/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../controller/forgot_password_email_controller.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  static const String name = '/forgotPasswordEmail';

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mailTEController = TextEditingController();
  String mailAddressContainer = '';
  final ForgotPasswordEmailController _forgotPasswordEmailController =
      Get.find<ForgotPasswordEmailController>();

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
                    'Your Email Address',
                    style: textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'A 6 digits verification OTP will send on your mail',
                    style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildVerifyEmailForm(),
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
  Widget _buildVerifyEmailForm() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return 'enter a valid Mail Address';
            }
            return null;
          },
          controller: _mailTEController,
        ),
        const SizedBox(height: 48),
        GetBuilder<ForgotPasswordEmailController>(builder: (controller) {
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
      _recoverVerifyEmail();
    }
  }

  Future<void> _recoverVerifyEmail() async {
    final bool result = await _forgotPasswordEmailController
        .verifyEmailAddress(_mailTEController.text.trim());

    if (result) {
      mailAddressContainer = _mailTEController.text.trim();

      Get.off(ForgotPasswordOtpScreen(mailAddress: mailAddressContainer));
    } else {
      showSnackBarMessage(
          context, _forgotPasswordEmailController.errorMessage!, true);
    }
  }

  void _onTapSignIn() {
    Get.back(); // to Back previous Screen
  }

  @override
  void dispose() {
    _mailTEController.dispose();
    super.dispose();
  }
}
