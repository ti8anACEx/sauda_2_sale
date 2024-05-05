import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/features/home/controllers/home_controller.dart';
import 'package:sauda_2_sale/features/home/pages/home_page.dart';
import 'package:sauda_2_sale/models/item_model.dart';

class ItemController extends GetxController {
  ItemModel? itemModel;
  HomeController homeController = Get.find(tag: 'home-controller');

  RxBool isRequestingRevoke = false.obs;
  RxBool isDeleting = false.obs;
  RxBool isLoading = true.obs;
  RxBool isPushedToSale = false.obs;

  RxString pushedRate = ''.obs;
  RxString pushedDate = ''.obs;
  RxString pushedProductName = ''.obs;
  RxString pushedDescription = ''.obs;

  RxList<String> pushedImageLinks = <String>[].obs;

  RxInt displayingImageIndex = 0.obs;
  DocumentSnapshot<Object?> item;
  Map<String, dynamic>? data;

  ItemController({required this.item}) {
    itemModel = ItemModel.fromSnap(item);

    isPushedToSale.value = itemModel!.isPushedToSale;
    pushedRate.value = itemModel!.pushedRate;
    pushedDate.value = itemModel!.pushedDate;
    pushedProductName.value = itemModel!.pushedProductName;
    pushedDescription.value = itemModel!.pushedDescription;
    pushedImageLinks.value = itemModel!.pushedImageLinks;

    data = item.data() as Map<String, dynamic>;
  }

  Future<void> revokeFromSale(ItemController itemController) async {
    removeFiles(itemController).then((value) async {
      Map<String, dynamic> fieldsToUpdate = {
        'pushedRate': '',
        'pushedDate': '',
        'pushedDescription': '',
        'pushedProductName': '',
        'pushedImageLinks': [],
        'isPushedToSale': false,
      };
      await updateItemFields(fieldsToUpdate, itemController);
    });
  }

  Future<void> removeFiles(ItemController itemController) async {
    isDeleting.value = true;

    try {
      final storage = FirebaseStorage.instance;
      final directoryRef = storage.ref().child(
          'uploads/items/${itemController.itemModel!.itemId}/pushedImages/');

      final ListResult listResult = await directoryRef.listAll();

      await Future.forEach(listResult.items, (Reference item) async {
        await item.delete();
      });
      Get.snackbar('Success', 'Revoked the item from sale');
    } catch (e) {
      Get.snackbar('Erroe', 'Failed to remove the item from sale');
    } finally {
      isDeleting.value = false;
    }
  }

  // Update function
  Future<void> updateItemFields(Map<String, dynamic> fieldsToUpdate,
      ItemController itemController) async {
    try {
      DocumentReference itemRef = FirebaseFirestore.instance
          .collection('items')
          .doc(itemController.itemModel!.itemId);
      await itemRef.update(fieldsToUpdate);
      itemController.isPushedToSale.value = true;
      Get.snackbar('Success', 'Revoked successfully!');
      itemController.isPushedToSale.value = false;

      homeController.fetchPosts();
      itemController.refresh();
      Get.off(() => HomePage());
    } catch (e) {
      log('Error updating item fields: $e');
      // Handle error here
    }
  }
}
