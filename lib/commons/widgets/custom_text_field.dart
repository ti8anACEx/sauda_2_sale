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
      labelText: labelText,
      labelStyle: const TextStyle(fontWeight: FontWeight.w300),
      contentPadding: const EdgeInsets.all(10.0),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: pinkColor, width: 2.0),
        borderRadius: BorderRadius.zero,
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
