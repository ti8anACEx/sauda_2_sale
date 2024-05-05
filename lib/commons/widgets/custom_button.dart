import 'package:flutter/material.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/constants/styles.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButton extends StatelessWidget {
  final Widget trailingWidget;
  final String text;
  final MainAxisAlignment mainAxisAlignment;
  final VoidCallback onTap;
  final Color? color;
  final double? borderRadius;
  final double? height;
  final bool? shadowEnabled;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 60,
    this.color = const Color.fromRGBO(203, 62, 249, 1),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.borderRadius = 30,
    this.shadowEnabled = true,
    this.trailingWidget = const SizedBox(),
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.screenWidth - 25,
        height: height,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: ShapeDecoration(
            shadows: [
              shadowEnabled!
                  ? BoxShadow(
                      color: color!.withOpacity(0.12),
                      spreadRadius: 5,
                      blurRadius: 10)
                  : BoxShadow(color: transparentColor)
            ],
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius!)))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Text(
                text,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: bold),
              ),
              trailingWidget,
            ],
          ),
        ),
      ),
    );
  }
}
