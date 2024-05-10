import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_box.dart';
import 'package:sauda_2_sale/commons/widgets/custom_button.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/product_details/widgets/product_images.dart';
import 'package:sauda_2_sale/features/upload/pages/push_to_sale_page.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../confidential/apis.dart';
import '../../../constants/utils.dart';
import '../widgets/single_image_view.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatelessWidget {
  final ItemController itemController;
  const ProductDetailsPage({super.key, required this.itemController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Product Details".text.black.make(),
          centerTitle: true,
          shadowColor: transparentColor,
          backgroundColor: transparentColor,
          leading: const Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ).onTap(() {
            Get.back();
            itemController.isRequestingRevoke.value = false;
          }),
          // actions: const [
          //   Icon(
          //     Icons.more_vert,
          //     color: blackColor,
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProductImages(itemController: itemController),
              15.heightBox,
              itemController.itemModel!.draftProductName.text
                  .size(22)
                  .bold
                  .make(),
              5.heightBox,
              itemController.itemModel!.weaverProductName.text
                  .size(18)
                  .fontWeight(FontWeight.w600)
                  .make(),
              15.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Rate : ".text.bold.size(16).make(),
                  itemController.itemModel!.draftRate.text.size(16).make(),
                  35.widthBox,
                  "Date : ".text.bold.size(16).make(),
                  itemController.itemModel!.draftDate.text.size(16).make(),
                ],
              ),
              15.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    customBox(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            "Agent : ".text.bold.make(),
                            itemController.itemModel!.agent.text.make(),
                          ],
                        ),
                        5.heightBox,
                        Row(
                          children: [
                            "Number : ".text.bold.make(),
                            itemController.itemModel!.agentPhoneNumber.text
                                .make(),
                          ],
                        ),
                      ],
                    )),
                    15.heightBox,
                    customBox(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            "Weaver : ".text.bold.make(),
                            itemController.itemModel!.weaver.text.make(),
                          ],
                        ),
                        5.heightBox,
                        Row(
                          children: [
                            "Number : ".text.bold.make(),
                            itemController.itemModel!.weaverPhoneNumber.text
                                .make(),
                          ],
                        ),
                      ],
                    )),
                    15.heightBox,
                    customBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Description : ".text.bold.make(),
                          Expanded(
                              child: itemController.itemModel!.description.text
                                  .make()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              30.heightBox,
              Obx(() => itemController.isPushedToSale.value
                  ? Column(
                      children: [
                        Wrap(
                          spacing: 20,
                          runSpacing: 25,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // ignore: prefer_interpolation_to_compose_strings
                                String url = APIs.whatsappLink1 +
                                    APIs.whatsappLink2 +
                                    itemController.itemModel!.agentPhoneNumber +
                                    APIs.whatsappLink4 +
                                    'Hello, I want to Re-Order the item - ' +
                                    itemController.itemModel!.draftProductName +
                                    ', Desc: ' +
                                    itemController.itemModel!.description +
                                    APIs.whatsappLink6;
                                launchTheUrl(url);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  backgroundColor: darkPinkColor),
                              child: "Re-order".text.make(),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // ignore: prefer_interpolation_to_compose_strings
                                String url = APIs.whatsappLink1 +
                                    APIs.whatsappLink2 +
                                    itemController
                                        .itemModel!.weaverPhoneNumber +
                                    APIs.whatsappLink4 +
                                    'Hello, What\'s the price for - ' +
                                    itemController.itemModel!.draftProductName +
                                    ', Desc: ' +
                                    itemController.itemModel!.description +
                                    APIs.whatsappLink6;
                                launchTheUrl(url);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  backgroundColor: darkPinkColor),
                              child: "Ask Rate".text.make(),
                            ),
                          ],
                        ),
                        25.heightBox,
                        Container(
                            height: 1,
                            color: pinkColor,
                            width: context.screenWidth),
                        15.heightBox,
                        "Product has been pushed to sale"
                            .text
                            .bold
                            .size(18)
                            .make(),
                        "with the following details :"
                            .text
                            .bold
                            .size(18)
                            .make(),
                        15.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                                itemController.pushedImageLinks.length,
                                (index) {
                              return SingleImageview(
                                  index: index,
                                  singleImageType: SingleImageType.pushed,
                                  itemController: itemController);
                            }),
                          ),
                        ),
                        15.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Rate : ".text.bold.make(),
                            itemController.pushedRate.value.text.make(),
                            15.widthBox,
                            "Date : ".text.bold.make(),
                            itemController.pushedDate.value.text.make(),
                          ],
                        ),
                        15.heightBox,
                        itemController.pushedProductName.value.text.bold
                            .size(18)
                            .make(),
                        5.heightBox,
                        itemController.pushedDescription.value.text.bold
                            .size(18)
                            .make(),
                        15.heightBox,
                        CustomButton(
                          text: itemController.isRequestingRevoke.value
                              ? 'Are you sure?'
                              : 'Revoke from Sale',
                          onTap: () {
                            if (itemController.isRequestingRevoke.value) {
                              itemController
                                  .revokeFromSale(itemController)
                                  .then((value) {
                                itemController.isRequestingRevoke.toggle();
                              });
                            } else {
                              itemController.isRequestingRevoke.toggle();
                            }
                          },
                          trailingWidget: Icon(
                            itemController.isRequestingRevoke.value
                                ? Icons.check_rounded
                                : Icons.arrow_forward_ios,
                            color: whiteColor,
                          ),
                        ),
                        15.heightBox,
                      ],
                    )
                  : Wrap(
                      spacing: 20,
                      runSpacing: 25,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              backgroundColor: darkPinkColor),
                          child: "Re-order".text.make(),
                        ),
                        ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              backgroundColor: darkPinkColor),
                          child: "Ask Rate".text.make(),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.off(() =>
                                PushToSalePage(itemController: itemController));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              backgroundColor: darkPinkColor),
                          child: "Push to sale".text.make(),
                        ),
                      ],
                    )),
              20.heightBox,
            ],
          ),
        ));
  }
}
