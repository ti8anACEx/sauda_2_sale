import 'package:flutter/material.dart';

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

// class CustomBox extends StatelessWidget {
//   final String label;
//   final String text;

//   CustomBox({required this.label, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             top: -16.0,
//             left: 8.0,
//             child: Container(
//               color: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 4.0),
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 16.0,
//             left: 8.0,
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
