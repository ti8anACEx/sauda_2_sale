import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_button.dart';
import 'package:sauda_2_sale/commons/widgets/custom_progress_indicator.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/product_details/controllers/edit_controller.dart';
import 'package:sauda_2_sale/features/upload/widgets/small_text_field.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/image_dislpay.dart';

// ignore: must_be_immutable
class EditPage extends StatelessWidget {
  final EditController editController;
  const EditPage({super.key, required this.editController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Edit Product Details".text.black.make(),
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
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageDisplay(
                    editController: editController,
                  ),
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
                                controller: editController.rateController),
                          ],
                        ),
                      ),
                      20.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Date".text.make(),
                            5.heightBox,
                            smallTextField(
                                controller: editController.dateController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  22.heightBox,
                  "Weaver's Product Name".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: editController.weaverProductNameController),
                  22.heightBox,
                  "New Name (for product)".text.make(),
                  5.heightBox,
                  smallTextField(controller: editController.newNameController),
                  22.heightBox,
                  "Weaver's Name".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: editController.weaverNameController),
                  22.heightBox,
                  "Description".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: editController.descriptionController),
                  22.heightBox,
                  "Weaver Phone Number".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: editController.weaverPhoneNumberController),
                  22.heightBox,
                  "Agent Name".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: editController.agentNameController),
                  22.heightBox,
                  "Agent Phone Number".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: editController.agentPhoneNumberController),
                  25.heightBox,
                  editController.isLoading.value
                      ? customProgressIndicator()
                      : CustomButton(
                          text: 'Finish Editing',
                          onTap: () async {
                            await editController.uploadAsDraft();
                          },
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                  20.heightBox,
                ],
              ),
            ),
          ),
        ));
  }
}
