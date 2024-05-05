import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/home/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class TopicBox extends StatelessWidget {
  final String text;
  TopicBox({
    super.key,
    required this.text,
  });

  final HomeController homeController = Get.find(tag: 'home-controller');

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          elevation: 21,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(7).copyWith(left: 11, right: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 19,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                homeController.currentTag.value == text
                    ? const WidthBox(5)
                    : Container(),
                homeController.currentTag.value == text
                    ? const Icon(Icons.close_rounded,
                        size: 17, color: textfieldGrey)
                    : Container(),
              ],
            ),
          ).onTap(() {
            homeController.updateCurrentTag(text);
          }),
        ),
      ),
    );
  }
}
