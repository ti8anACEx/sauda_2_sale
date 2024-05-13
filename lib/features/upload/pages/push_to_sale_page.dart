import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_button.dart';
import 'package:sauda_2_sale/commons/widgets/custom_progress_indicator.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/upload/controllers/push_to_sale_controller.dart';
import 'package:sauda_2_sale/features/upload/widgets/image_display_2.dart';
import 'package:sauda_2_sale/features/upload/widgets/small_text_field.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class PushToSalePage extends StatelessWidget {
  final ItemController itemController;
  PushToSalePage({super.key, required this.itemController}) {
    pushToSaleController = Get.put(
        PushToSaleController(itemController: itemController),
        tag: 'push-to-sale-controller');
  }

  late PushToSaleController pushToSaleController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              "Push ${pushToSaleController.itemController.itemModel!.draftProductName} to Sale"
                  .text
                  .black
                  .make(),
          centerTitle: true,
          shadowColor: transparentColor,
          backgroundColor: transparentColor,
          leading: const Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ).onTap(() {
            Get.back();
          }),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageDisplay2(),
                20.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Rate".text.make(),
                          5.heightBox,
                          smallTextField(
                              controller: pushToSaleController.rateController),
                        ],
                      ),
                    ),
                    20.widthBox,
                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       "Date".text.make(),
                    //       5.heightBox,
                    //       smallTextField(
                    //           controller: pushToSaleController.dateController),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                15.heightBox,
                "Product Name (to be displayed to customers)".text.make(),
                smallTextField(
                    controller: pushToSaleController.productNameController),
                15.heightBox,
                "Description".text.make(),
                smallTextField(
                    controller: pushToSaleController.descriptionController),
                25.heightBox,
                Obx(
                  () => pushToSaleController.isUploadingFiles.value
                      ? customProgressIndicator()
                      : CustomButton(
                          text: 'Push To Sale',
                          onTap: () async {
                            await pushToSaleController.pushToSale();
                          },
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                ),
                20.heightBox,
              ],
            ),
          ),
        ));
  }
}
