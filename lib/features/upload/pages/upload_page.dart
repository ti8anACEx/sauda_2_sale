import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_button.dart';
import 'package:sauda_2_sale/commons/widgets/custom_progress_indicator.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/upload/controllers/upload_controller.dart';
import 'package:sauda_2_sale/features/upload/widgets/image_display.dart';
import 'package:sauda_2_sale/features/upload/widgets/small_text_field.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class UploadPage extends StatelessWidget {
  UploadPage({super.key});

  UploadController uploadController =
      Get.put(UploadController(), tag: 'upload-controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Upload Product".text.black.make(),
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
                  ImageDisplay(),
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
                                controller: uploadController.rateController),
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
                                controller: uploadController.dateController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  22.heightBox,
                  "Weaver's Product Name".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.weaverProductNameController),
                  22.heightBox,
                  "New Name (for product)".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.newNameController),
                  22.heightBox,
                  "Weaver's Name".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.weaverNameController),
                  22.heightBox,
                  "Description".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.descriptionController),
                  22.heightBox,
                  "Weaver Phone Number".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.weaverPhoneNumberController),
                  22.heightBox,
                  "Agent Name".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.agentNameController),
                  22.heightBox,
                  "Agent Phone Number".text.make(),
                  5.heightBox,
                  smallTextField(
                      controller: uploadController.agentPhoneNumberController),
                  25.heightBox,
                  uploadController.isLoading.value
                      ? customProgressIndicator()
                      : CustomButton(
                          text: 'Upload as draft',
                          onTap: () async {
                            await uploadController.uploadAsDraft();
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
