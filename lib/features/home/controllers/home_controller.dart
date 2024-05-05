import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sauda_2_sale/features/auth/controllers/auth_controller.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/product_details/pages/product_details_page.dart';
import 'package:sauda_2_sale/features/upload/pages/upload_page.dart';

class HomeController extends GetxController {
  RxString currentTag = ''.obs;
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = true.obs;
  RxBool isSearching = false.obs;

  RxList<DocumentSnapshot> searchedItems = <DocumentSnapshot>[].obs;
  RxList<DocumentSnapshot> items = <DocumentSnapshot>[].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthController authController = Get.find(tag: 'auth-controller');

  @override
  void onInit() {
    super.onInit();
    fetchPosts(); // interchangeable with fetchItems
  }

  void updateCurrentTag(String text) {
    if (currentTag.value == text) {
      currentTag.value = '';
    } else {
      currentTag.value = text;
    }
  }

  void addItem() {
    Get.to(() => UploadPage());
  }

  void openProductDetails(ItemController itemController) {
    Get.to(() => ProductDetailsPage(itemController: itemController));
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('items')
          .where('vendorUid', isEqualTo: authController.currentUserUID.value)
          .get();
      items.value = querySnapshot.docs;

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", 'Failed to load posts');
    }
  }

  Future<void> searchQuery() async {
    try {
      isSearching.value = true;
      searchedItems.clear();
      QuerySnapshot querySnapshot = await firestore
          .collection('items')
          .where('draftProductName',
              isGreaterThanOrEqualTo: searchController.text)
          .where('vendorUid', isEqualTo: authController.currentUserUID.value)
          .get();
      searchedItems.value = querySnapshot.docs;
    } catch (e) {
      Get.snackbar("Error", 'Failed to load items');
    }
  }
}
