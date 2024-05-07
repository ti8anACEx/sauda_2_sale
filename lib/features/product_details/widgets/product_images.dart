import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/product_details/widgets/single_image_view.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class ProductImages extends StatelessWidget {
  final ItemController itemController;
  const ProductImages({super.key, required this.itemController});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(91, 148, 155, 144),
        width: context.screenWidth,
        child: Column(
          children: [
            20.heightBox,
            Obx(
              () => Material(
                elevation: 11,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      width: 300,
                      itemController.itemModel!.draftImageLinks[
                          itemController.displayingImageIndex.value],
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            15.heightBox,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    itemController.itemModel!.draftImageLinks.length, (index) {
                  return SingleImageview(
                          index: index, itemController: itemController)
                      .onTap(() {
                    itemController.displayingImageIndex.value = index;
                  });
                }),
              ),
            ),
            15.heightBox,
          ],
        ));
  }
}
