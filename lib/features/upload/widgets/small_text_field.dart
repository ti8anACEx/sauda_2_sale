import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sauda_2_sale/constants/colors.dart';

Widget smallTextField(
    {TextInputType? textInputType = TextInputType.text,
    String? hint = '',
    int? maxLength,
    String labelText = '',
    required TextEditingController controller}) {
  return TextField(
    controller: controller,
    style: GoogleFonts.poppins(),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontWeight: FontWeight.w300),
      contentPadding: const EdgeInsets.all(10.0),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.black.withOpacity(0.5), width: 0.67),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: pinkColor, width: 2.0),
        borderRadius: BorderRadius.circular(10),
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
