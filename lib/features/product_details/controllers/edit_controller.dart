import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/home/pages/home_page.dart';
import 'package:uuid/uuid.dart';

import '../../../models/item_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';

class EditController extends GetxController {
  TextEditingController rateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController weaverProductNameController = TextEditingController();
  TextEditingController weaverNameController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController agentNameController = TextEditingController();
  TextEditingController agentPhoneNumberController = TextEditingController();
  TextEditingController weaverPhoneNumberController = TextEditingController();

  RxList<Uint8List> draftImagesAsBytes = <Uint8List>[].obs;
  RxList<String> draftImagesLinks = <String>[].obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  AuthController authController = Get.find(tag: 'auth-controller');
  HomeController homeController = Get.find(tag: 'home-controller');

  RxBool isLoading = false.obs;
  RxBool isUploadingFiles = false.obs;
  ItemController itemController;

  EditController({required this.itemController}) {
    rateController.text = itemController.itemModel!.draftRate;
    dateController.text = itemController.itemModel!.draftDate;
    weaverProductNameController.text =
        itemController.itemModel!.weaverProductName;
    descriptionController.text = itemController.itemModel!.description;
    newNameController.text = itemController.itemModel!.draftProductName;
    agentNameController.text = itemController.itemModel!.agent;
    agentPhoneNumberController.text =
        itemController.itemModel!.agentPhoneNumber;
    weaverPhoneNumberController.text =
        itemController.itemModel!.weaverPhoneNumber;
    weaverNameController.text = itemController.itemModel!.weaver;
  }

  void checkAndClearList({int extra = 0}) {
    if ((draftImagesAsBytes.length + extra) >= 4) {
      draftImagesAsBytes.clear();
    }
  }

  Future<void> pickFiles() async {
    try {
      checkAndClearList();
      var pickedImgs = await ImagePicker().pickMultiImage();
      checkAndClearList(extra: pickedImgs.length);
      var len = 0;
      for (final image in pickedImgs) {
        len++;
        final imageBytes = await File(image.path).readAsBytes();
        draftImagesAsBytes.add(imageBytes);
        if (len >= 4) {
          return;
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> pickFilesWithCamera() async {
    try {
      checkAndClearList();

      var image = await ImagePicker().pickImage(source: ImageSource.camera);

      final imageBytes = await File(image!.path).readAsBytes();
      draftImagesAsBytes.add(imageBytes);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> uploadAsDraft() async {
    isLoading.value = true;
    if (checkIfNotEmpty()) {
      if (draftImagesAsBytes.isEmpty) {
        isLoading.value = false;
        return;
      }

      try {
        String itemId = const Uuid().v1();

        await uploadFiles(itemId).then((value) async {
          ItemModel itemModel = ItemModel(
            pushedDescription: '',
            isPushedToSale: false,
            vendorUsername: authController.currentUsername.value,
            vendorProfilePicUrl: authController.currentProfilePic.value,
            description: descriptionController.text,
            vendorUid: authController.currentUserUID.value,
            itemId: itemId,
            datePublished: DateTime.now(),
            draftImageLinks: draftImagesLinks,
            pushedImageLinks: [],
            agent: agentNameController.text,
            pushedRate: '',
            draftDate: dateController.text,
            agentPhoneNumber: agentPhoneNumberController.text,
            draftProductName: newNameController.text,
            draftRate: rateController.text,
            pushedDate: '',
            pushedProductName: '',
            weaver: weaverNameController.text,
            weaverPhoneNumber: weaverPhoneNumberController.text,
            weaverProductName: weaverProductNameController.text,
          );

          await firestore
              .collection('items')
              .doc(itemId)
              .set(itemModel.toJson());

          Get.snackbar("Success", "Uploads successful!");
          clearVars();
          homeController.fetchPosts();
        });
      } catch (e) {
        Get.snackbar("Error", e.toString());
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Failed", "Make sure to enter all fields properly");
      isLoading.value = false;
    }
  }

  Future<void> uploadFiles(String itemId) async {
    draftImagesLinks.clear();
    isUploadingFiles.value = true;
    try {
      for (int i = 0; i < draftImagesAsBytes.length; i++) {
        Uint8List fileBytes = draftImagesAsBytes[i];

        String draftImageName = 'draft_image_$i';

        Reference storageReference = storage
            .ref()
            .child('uploads/items/$itemId/draftImages/$draftImageName');
        UploadTask uploadTask = storageReference.putData(fileBytes);

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        draftImagesLinks.add(downloadURL);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploadingFiles.value = false;
    }
  }

  void clearVars() {
    draftImagesLinks.clear();
    draftImagesAsBytes.clear();
    rateController.clear();
    dateController.clear();
    weaverProductNameController.clear();
    weaverNameController.clear();
    newNameController.clear();
    descriptionController.clear();
    agentNameController.clear();
    agentPhoneNumberController.clear();
    weaverPhoneNumberController.clear();
  }

  bool checkIfNotEmpty() {
    return true;
    // return rateController.text.isNotEmpty &&
    //     dateController.text.isNotEmpty &&
    //     weaverProductNameController.text.isNotEmpty &&
    //     weaverNameController.text.isNotEmpty &&
    //     newNameController.text.isNotEmpty &&
    //     descriptionController.text.isNotEmpty &&
    //     agentNameController.text.isNotEmpty &&
    //     agentPhoneNumberController.text.isNotEmpty &&
    //     weaverPhoneNumberController.text.isNotEmpty;
  }

  Future<void> pushToSale() async {
    uploadFilesForUpdate().then((value) async {
      Map<String, dynamic> fieldsToUpdate = {
        'draftRate': rateController.text,
        'draftDate': dateController.text,
        'description': descriptionController.text,
        'draftImageLinks': [],
        'agent': agentNameController.text,
        'darftDate': dateController.text,
        'agentPhoneNumber': agentPhoneNumberController.text,
        'draftProductName': newNameController.text,
        'weaver': weaverNameController.text,
        'weaverPhoneNumber': weaverPhoneNumberController.text,
        'weaverProductName': weaverProductNameController.text,
      };
      await updateItemFields(fieldsToUpdate);
    });
  }

  Future<void> uploadFilesForUpdate() async {
    draftImagesLinks.clear();
    isUploadingFiles.value = true;
    try {
      for (int i = 0; i < draftImagesAsBytes.length; i++) {
        Uint8List fileBytes = draftImagesAsBytes[i];

        String draftImageName = 'draft_image_$i';

        Reference storageReference = storage.ref().child(
            'uploads/items/${itemController.itemModel!.itemId}/draftImages/$draftImageName');
        UploadTask uploadTask = storageReference.putData(fileBytes);

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        draftImagesLinks.add(downloadURL);
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

      Get.offAll(HomePage());

      itemController.refresh();
      Get.off(() => HomePage());
    } catch (e) {
      log('Error updating item fields: $e');
      // Handle error here
    }
  }
}
