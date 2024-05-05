import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/upload/controllers/upload_controller.dart';
import 'package:sauda_2_sale/features/upload/widgets/single_image_selection.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class ImageDisplay extends StatelessWidget {
  ImageDisplay({super.key});

  UploadController uploadController = Get.find(tag: 'upload-controller');

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: blackColor.withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: fontGrey,
              ),
              child: Column(
                children: [
                  15.heightBox,
                  "Selected ${uploadController.draftImagesAsBytes.length.toString()}/4 images"
                      .text
                      .color(whiteColor)
                      .make(),
                  10.heightBox,
                  uploadController.draftImagesAsBytes.isEmpty
                      ? "Please pick an image (max. 4)"
                          .text
                          .color(whiteColor)
                          .make()
                      : GFItemsCarousel(
                          rowCount: 2,
                          children: List.generate(
                              uploadController.draftImagesAsBytes.length,
                              (index) {
                            return SingleImageSelection(index: index);
                          })),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await uploadController.pickFiles();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            backgroundColor: darkPinkColor),
                        child: "Gallery".text.make(),
                      ),
                      20.widthBox,
                      const Icon(Icons.camera_alt, color: blackColor, size: 30)
                          .onTap(() {
                        uploadController.pickFilesWithCamera();
                      }),
                    ],
                  ),
                  10.heightBox,
                ],
              )),
        ),
      ),
    );
  }
}
