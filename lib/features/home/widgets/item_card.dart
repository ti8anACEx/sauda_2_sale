import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class ItemCard extends StatelessWidget {
  final ItemController itemController;

  ItemCard({super.key, required this.itemController});

  HomeController homeController = Get.find(tag: 'home-controller');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        homeController.openProductDetails(itemController);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: textfieldGrey.withOpacity(0.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    itemController.itemModel!.draftImageLinks[0],
                    fit: BoxFit.fitWidth,
                  ),
                ),
                5.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        "Rate : ".text.bold.size(14).make(),
                        itemController.itemModel!.draftRate.text
                            .fontWeight(FontWeight.w600)
                            .size(12)
                            .make(),
                      ],
                    ),
                    itemController.isPushedToSale.value
                        ? const Icon(Icons.check_circle, color: darkPinkColor)
                        : Container(),
                  ],
                ),
                5.heightBox,
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: itemController.itemModel!.draftProductName.text
                        .fontWeight(FontWeight.w800)
                        .size(12)
                        .make()),
                6.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
