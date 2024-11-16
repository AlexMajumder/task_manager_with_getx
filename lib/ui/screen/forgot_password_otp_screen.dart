import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/controller/forgot_password_otp_controller.dart';
import 'package:task_manager/ui/screen/reset_password_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({super.key, required this.mailAddress});

  final String mailAddress;

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpTEController = TextEditingController();
  final ForgotPasswordOtpController _forGotPasswordOtpController =
      Get.find<ForgotPasswordOtpController>();

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
                    'Pin Verification',
                    style: textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'A 6 digits verification OTP has been send on your mail',
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
        PinCodeTextField(
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return 'Enter Valid pin';
            }
            if (value!.length < 6) {
              return 'Pin must be at least 6 digits';
            }

            return null;
          },
          controller: _otpTEController,
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
        ),
        const SizedBox(height: 48),
        GetBuilder<ForgotPasswordOtpController>(builder: (controller) {
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
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    String otpContainer = _otpTEController.text;
    final bool result = await _forGotPasswordOtpController.verifyOtp(
        widget.mailAddress, otpContainer);

    if (result) {
      Get.off(ResetPasswordScreen(
          mailContainer: widget.mailAddress, otp: otpContainer));
    } else {
      showSnackBarMessage(
          context, _forGotPasswordOtpController.errorMessage!, true);
    }
  }

  void _onTapSignIn() {
    Get.offAllNamed(SignInScreen.name);
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
