import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_button.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/auth_controller.dart';

// ignore: must_be_immutable
class OTPPage extends StatelessWidget {
  OTPPage({super.key});

  AuthController authController = Get.find(tag: 'auth-controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              20.heightBox,
              Image.asset('assets/images/sauda2sale_png.png'),
              25.heightBox,
              "Sauda Book".text.size(35).semiBold.make(),
              25.heightBox,
              "Enter the OTP sent to +91 ${authController.phoneNumberController.text}"
                  .text
                  .align(TextAlign.center)
                  .size(12)
                  .fontWeight(FontWeight.w500)
                  .make(),
              20.heightBox,
              OtpTextField(
                enabledBorderColor: blackColor,
                keyboardType: TextInputType.number,
                numberOfFields: authController.verificationCodeLength,
                borderColor: const Color(0xFF512DA8),
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  authController.verificationCodeEntered.value =
                      verificationCode;
                  authController.verifyOTP();
                }, // end onSubmit
              ),
              20.heightBox,
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  "Didn't you receive the OTP? ".text.size(12).make(),
                  "Resend OTP"
                      .text
                      .size(13)
                      .fontWeight(FontWeight.bold)
                      .color(darkPinkColor)
                      .make()
                      .onTap(() async {
                    await authController.resendOTP();
                  }),
                ],
              ),
              20.heightBox,
              CustomButton(
                text: "Verify",
                mainAxisAlignment: MainAxisAlignment.center,
                onTap: () async {
                  await authController.verifyOTP();
                },
                color: pinkColor,
              ),
              50.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
