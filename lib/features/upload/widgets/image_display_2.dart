import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/upload/controllers/push_to_sale_controller.dart';
import 'package:sauda_2_sale/features/upload/widgets/single_image_selection_2.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class ImageDisplay2 extends StatelessWidget {
  ImageDisplay2({super.key});

  PushToSaleController pushToSaleController =
      Get.find(tag: 'push-to-sale-controller');

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
                  "Selected ${pushToSaleController.pushedImagesAsBytes.length.toString()}/4 images"
                      .text
                      .color(whiteColor)
                      .make(),
                  10.heightBox,
                  pushToSaleController.pushedImagesAsBytes.isEmpty
                      ? "Please pick an image (max. 4)"
                          .text
                          .color(whiteColor)
                          .make()
                      : GFItemsCarousel(
                          rowCount: 2,
                          children: List.generate(
                              pushToSaleController.pushedImagesAsBytes.length,
                              (index) {
                            return SingleImageSelection2(index: index);
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await pushToSaleController.pickFiles();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pinkColor),
                        child: "Gallery".text.make(),
                      ),
                      20.widthBox,
                      const Icon(Icons.camera_alt, color: blackColor, size: 30)
                          .onTap(() {
                        pushToSaleController.pickFilesWithCamera();
                      }),
                    ],
                  ),
                  15.heightBox,
                ],
              )),
        ),
      ),
    );
  }
}
