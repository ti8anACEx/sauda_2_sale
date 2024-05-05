import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_button.dart';
import 'package:sauda_2_sale/commons/widgets/custom_text_field.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/auth_controller.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  AuthController authController = Get.find(tag: 'auth-controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            50.heightBox,
            "Sauda Book".text.size(35).semiBold.make(),
            50.heightBox,
            customTextField(
                labelText: 'Username',
                controller: authController.usernameController),
            10.heightBox,
            customTextField(
                labelText: 'Phone Number',
                textInputType: TextInputType.phone,
                controller: authController.phoneNumberController),
            10.heightBox,
            customTextField(
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
                controller: authController.emailController),
            10.heightBox,
            customTextField(
                labelText: 'Password',
                controller: authController.passwordController),
            100.heightBox,
            CustomButton(
              text: "Get OTP",
              trailingWidget: const Icon(
                Icons.arrow_forward_ios,
                color: whiteColor,
              ),
              onTap: () async {
                await authController.getOTP();
              },
              color: pinkColor,
            ),
            50.heightBox,
          ],
        ),
      ),
    );
  }
}
