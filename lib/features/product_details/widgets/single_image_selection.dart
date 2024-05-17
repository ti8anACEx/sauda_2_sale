// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/edit_controller.dart';

class SingleImageSelection extends StatelessWidget {
  final EditController editController;
  final int index;
  const SingleImageSelection(
      {super.key, required this.editController, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(
                          editController.draftImagesAsBytes[index],
                        ),
                        fit: BoxFit.cover)),
              )),
          const Icon(Icons.cancel).onTap(() {
            editController.draftImagesAsBytes.removeAt(index);
          }),
        ],
      ),
    );
  }
}
