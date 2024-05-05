import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/features/upload/controllers/upload_controller.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class SingleImageSelection extends StatelessWidget {
  final int index;
  SingleImageSelection({super.key, required this.index});
  UploadController uploadController = Get.find(tag: 'upload-controller');

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
                          uploadController.draftImagesAsBytes[index],
                        ),
                        fit: BoxFit.cover)),
              )),
          const Icon(Icons.cancel).onTap(() {
            uploadController.draftImagesAsBytes.removeAt(index);
          }),
        ],
      ),
    );
  }
}
