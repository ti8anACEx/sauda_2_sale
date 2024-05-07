import 'package:flutter/material.dart';
import 'package:sauda_2_sale/constants/colors.dart';

Widget customTextField(
    {TextInputType? textInputType = TextInputType.text,
    String? hint = '',
    int? maxLength,
    String labelText = '',
    required TextEditingController controller}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      fillColor: fontGrey.withOpacity(0.15),
      filled: true,
      labelText: labelText,
      labelStyle: const TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
      contentPadding: const EdgeInsets.all(8.0),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: pinkColor, width: 2.0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black),
    ),
    textAlign: TextAlign.start,
    maxLength: maxLength,
    keyboardType: textInputType,
    onChanged: (value) {
      // Handle onChanged event if needed
    },
  );
}
