import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/features/auth/controllers/auth_controller.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/product_details/pages/product_details_page.dart';
import 'package:sauda_2_sale/features/upload/pages/upload_page.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeController extends GetxController {
  RxString currentTag = ''.obs;
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = true.obs;
  RxBool isSearching = false.obs;
  double min = 0, max = 500; // for Price filters

  RxList<DocumentSnapshot> searchedItems = <DocumentSnapshot>[].obs;
  RxList<DocumentSnapshot> filteredSearchItems = <DocumentSnapshot>[].obs;

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
          .where('vendorUid', isEqualTo: authController.currentUserUID.value)
          .get();

      searchedItems.value = querySnapshot.docs.where((docu) {
        Map<String, dynamic> data = docu.data() as Map<String, dynamic>;
        return data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase()));
      }).toList();
    } catch (e) {
      Get.snackbar("Error", 'Failed to load items $e');
    }
  }

  void showTheFilter(String filterName, BuildContext context) {
    switch (filterName) {
      case 'Rate':
        showPriceFilter(context);
        break;
      case 'Date':
        showDateFilter(context);
        break;
      case 'Pushed/Not Pushed':
        showPushedFilter(context);
        break;
      case 'A-Z':
        showAtoZFilter(context);
        break;
      default:
    }
  }

  Future<void> filteredSearchQuery({
    String collection = 'items',
    double minRate = 0,
    double maxRate = 500,
    String orderBy = '',
    bool oldestFirst = false,
    bool newestFirst = false,
    bool pushedToSaleItems = false,
    bool notPushedToSaleItems = false,
    bool aToZOrder = false,
    bool zToAOrder = false,
  }) async {
    try {
      isSearching.value = true;
      searchedItems.clear();
      if (orderBy == 'default') {
        isSearching.value = false;
        return;
      }
      Query query = firestore.collection(collection);

      // Fetch all documents without initial filtering
      QuerySnapshot querySnapshot = await query
          .where('vendorUid', isEqualTo: authController.currentUserUID.value)
          .get();

      // Convert QuerySnapshot to List<DocumentSnapshot>
      List<DocumentSnapshot> allDocuments = querySnapshot.docs;

      // Apply filtering logic on the client-side
      List<DocumentSnapshot> filteredDocuments = allDocuments.where((doc) {
        // Filter based on rate
        double rate = double.parse(doc['draftRate']);
        if (rate < minRate || rate > maxRate) {
          return false;
        }

        // Filter based on pushed/not pushed to sale items
        bool isPushedToSale = doc['isPushedToSale'] ?? false;
        if (pushedToSaleItems && !isPushedToSale) {
          return false;
        }
        if (notPushedToSaleItems && isPushedToSale) {
          return false;
        }

        // Add other filters as needed

        return true; // Document passes all filters
      }).toList();

      // Apply sorting logic on the client-side
      if (oldestFirst) {
        filteredDocuments.sort((a, b) => (a['datePublished'] as Timestamp)
            .compareTo(b['datePublished'] as Timestamp));
      } else if (newestFirst) {
        filteredDocuments.sort((a, b) => (b['datePublished'] as Timestamp)
            .compareTo(a['datePublished'] as Timestamp));
      } else if (aToZOrder) {
        filteredDocuments.sort((a, b) => (a['draftProductName'] as String)
            .compareTo(b['draftProductName'] as String));
      } else if (zToAOrder) {
        filteredDocuments.sort((a, b) => (b['draftProductName'] as String)
            .compareTo(a['draftProductName'] as String));
      }

      // Update searchedItems with the filtered and sorted documents
      searchedItems.value = filteredDocuments;
    } catch (e) {
      Get.snackbar("Error", 'Failed to load items $e');
    }
  }

  void showPriceFilter(BuildContext context) {
    Rx<RangeValues> values = Rx<RangeValues>(RangeValues(min, max));
    Rx<RangeLabels> labels = Rx<RangeLabels>(RangeLabels(
        values.value.start.toString(), values.value.end.toString()));
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            "Rate".text.make(),
            20.heightBox,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(10, (index) {
                    double val = (min + (max / 10)) * (index + 1);
                    return Text(
                      val.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 9),
                    );
                  }),
                ),
                Obx(
                  () => RangeSlider(
                    labels: labels.value,
                    divisions: 10,
                    min: min,
                    activeColor: pinkColor,
                    inactiveColor: textfieldGrey.withOpacity(0.3),
                    max: max,
                    values: values.value,
                    onChanged: (newValue) {
                      values.value = newValue;
                    },
                  ),
                ),
              ],
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(orderBy: 'default');
                    Get.back(); // Close the filter modal
                  },
                  child: "Default".text.make(),
                ),
                20.widthBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(
                        minRate: values.value.start, maxRate: values.value.end);
                    Get.back(); // Close the filter modal
                  },
                  child: "OK".text.make(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showDateFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(oldestFirst: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Oldest First".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(newestFirst: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Newest First".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(orderBy: 'default');
                    Get.back(); // Close the filter modal
                  },
                  child: "Default".text.make(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPushedFilter(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      elevation: 0,
      context: context,
      builder: (context) {
        return Container(
          color: whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  filteredSearchQuery(
                      pushedToSaleItems:
                          true); // Implement logic for pushed to sale items
                  Get.back(); // Close the filter modal
                },
                child: "Pushed to Sale Items".text.make(),
              ),
              10.heightBox,
              ElevatedButton(
                onPressed: () {
                  filteredSearchQuery(
                      notPushedToSaleItems:
                          true); // Implement logic for not pushed to sale items
                  Get.back(); // Close the filter modal
                },
                child: "Not Pushed to Sale Items".text.make(),
              ),
              10.heightBox,
              ElevatedButton(
                onPressed: () {
                  filteredSearchQuery(orderBy: 'default');
                  Get.back(); // Close the filter modal
                },
                child: "Default".text.make(),
              ),
            ],
          ),
        );
      },
    );
  }

  void showAtoZFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(aToZOrder: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Order by A-Z".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(zToAOrder: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Order by Z-A".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(orderBy: 'default');
                    Get.back(); // Close the filter modal
                  },
                  child: "Default".text.make(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
