import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sauda_2_sale/features/home/controllers/home_controller.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/home/pages/home_page.dart';
import 'package:velocity_x/velocity_x.dart';

class PushToSaleController extends GetxController {
  TextEditingController rateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  RxBool isUploadingFiles = false.obs;
  RxList<Uint8List> pushedImagesAsBytes = <Uint8List>[].obs;
  RxList<String> pushedImageLinks = <String>[].obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  ItemController itemController;
  HomeController homeController = Get.find(tag: 'home-controller');

  PushToSaleController({required this.itemController});

  Future<void> pickFiles() async {
    try {
      var files = await FilePicker.platform.pickFiles(
          type: FileType.image, allowMultiple: true, allowCompression: true);
      pushedImagesAsBytes.clear();

      if (files != null && files.files.length > 4) {
        VxToast.show(Get.context!,
            msg:
                "Maximum 4 images allowed"); // restricting number of images to 4
      }

      if (!kIsWeb) {
        if (files != null && files.files.isNotEmpty) {
          for (int i = 0; i < files.files.length; i++) {
            pushedImagesAsBytes
                .add(await File(files.files[i].path!).readAsBytes());
          }
        }
      } else if (files != null && files.files.isNotEmpty) {
        for (int i = 0; i < files.files.length; i++) {
          pushedImagesAsBytes.add(files.files[i].bytes!);
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> pickFilesWithCamera() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage();

      // ignore: unnecessary_null_comparison
      if (pickedImages != null) {
        if (pickedImages.length > 4) {
          Get.snackbar('Attention', "Maximum 4 images allowed");
          return; // Exit the function if more than 4 images are picked
        }

        for (final image in pickedImages) {
          final imageBytes = await File(image.path).readAsBytes();
          pushedImagesAsBytes.add(imageBytes);
        }
      } else {
        log('User canceled or closed the camera');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  bool ckeckIfNotEmpty() {
    // return rateController.text.isNotEmpty &&
    //     dateController.text.isNotEmpty &&
    //     descriptionController.text.isNotEmpty &&
    //     productNameController.text.isNotEmpty &&
    //     pushedImagesAsBytes.isNotEmpty &&
    //     pushedImageLinks.isNotEmpty &&
    // pushedImageLinks.length == pushedImagesAsBytes.length;
    return pushedImageLinks.length == pushedImagesAsBytes.length;
  }

  Future<void> pushToSale() async {
    uploadFiles().then((value) async {
      if (ckeckIfNotEmpty()) {
        Map<String, dynamic> fieldsToUpdate = {
          'pushedRate': rateController.text,
          'pushedDate': dateController.text,
          'pushedDescription': descriptionController.text,
          'pushedProductName': productNameController.text,
          'pushedImageLinks': pushedImageLinks,
          'isPushedToSale': true,
        };
        await updateItemFields(fieldsToUpdate);
      } else {
        Get.snackbar('Failed', 'Fill all the fields');
      }
    });
  }

  Future<void> uploadFiles() async {
    pushedImageLinks.clear();
    isUploadingFiles.value = true;
    try {
      for (int i = 0; i < pushedImagesAsBytes.length; i++) {
        Uint8List fileBytes = pushedImagesAsBytes[i];

        String pushedImageName = 'pushed_image_$i';

        Reference storageReference = storage.ref().child(
            'uploads/items/${itemController.itemModel!.itemId}/pushedImages/$pushedImageName');
        UploadTask uploadTask = storageReference.putData(fileBytes);

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        pushedImageLinks.add(downloadURL);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploadingFiles.value = false;
    }
  }

  // Update function
  Future<void> updateItemFields(Map<String, dynamic> fieldsToUpdate) async {
    try {
      DocumentReference itemRef = FirebaseFirestore.instance
          .collection('items')
          .doc(itemController.itemModel!.itemId);
      await itemRef.update(fieldsToUpdate);
      itemController.isPushedToSale.value = true;
      Get.snackbar('Success', 'Pushed to sale successfully!');

      await homeController.fetchPosts();
      itemController.pushedDate.value = dateController.text;
      itemController.pushedRate.value = rateController.text;
      itemController.pushedProductName.value = productNameController.text;
      itemController.pushedDescription.value = descriptionController.text;
      itemController.pushedImageLinks = pushedImageLinks;

      itemController.refresh();
      clearvars();
      Get.off(() => HomePage());
    } catch (e) {
      log('Error updating item fields: $e');
      // Handle error here
    }
  }

  void clearvars() {
    rateController.clear();
    dateController.clear();
    descriptionController.clear();
    productNameController.clear();
    pushedImagesAsBytes.clear();
    pushedImageLinks.clear();
  }
}
