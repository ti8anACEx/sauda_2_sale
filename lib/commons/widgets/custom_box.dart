import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants/colors.dart';

Widget customBox({required Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      color: textfieldGrey.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: child,
      ),
    ),
  );
}
