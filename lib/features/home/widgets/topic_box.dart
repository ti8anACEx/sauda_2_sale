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
        padding: const EdgeInsets.all(8.0).copyWith(top: 2, bottom: 17),
        child: Material(
          color: fontGrey,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Material(
              color: whiteColor,
              borderRadius: BorderRadius.circular(25),
              child: Padding(
                padding: const EdgeInsets.all(7).copyWith(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 15,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w400,
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
        ),
      ),
    );
  }
}
