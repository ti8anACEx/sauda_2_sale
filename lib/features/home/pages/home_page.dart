import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/commons/widgets/custom_progress_indicator.dart';
import 'package:sauda_2_sale/commons/widgets/custom_search_bar.dart';
import 'package:sauda_2_sale/constants/colors.dart';
import 'package:sauda_2_sale/constants/lists.dart';
import 'package:sauda_2_sale/features/home/controllers/home_controller.dart';
import 'package:sauda_2_sale/features/home/controllers/item_controller.dart';
import 'package:sauda_2_sale/features/home/widgets/item_card.dart';
import 'package:sauda_2_sale/features/home/widgets/topic_box.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController homeController =
      Get.put(HomeController(), tag: 'home-controller');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 11,
            onPressed: () {
              homeController.addItem();
            },
            backgroundColor: darkPinkColor,
            child: const Icon(Icons.add, size: 30),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: pinkColor,
                child: Column(
                  children: [
                    // Search Bar
                    15.heightBox,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customSearchBar(),
                    ),
                    10.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(customTags.length, (index) {
                          return TopicBox(
                            text: customTags[index]['title'],
                          );
                        }),
                      ),
                    ),
                    10.heightBox,
                  ],
                ),
              ),
              7.heightBox,
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: "Recent Uploads"
                    .text
                    .size(20)
                    .fontWeight(FontWeight.w600)
                    .make(),
              ),
              10.heightBox,
              Obx(
                () => Expanded(
                  child: homeController.isSearching.value
                      ? MasonryGridView.builder(
                          itemCount: homeController.searchedItems.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Object?> searchedItem =
                                homeController.searchedItems[index];

                            final ItemController itemController = Get.put(
                                ItemController(
                                  item: searchedItem,
                                ),
                                tag:
                                    'searchedItemId_${searchedItem['itemId']}');

                            return ItemCard(
                              itemController: itemController,
                            );
                          },
                        )
                      : homeController.isLoading.value
                          ? customProgressIndicator()
                          : MasonryGridView.builder(
                              itemCount: homeController.items.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                DocumentSnapshot<Object?> item =
                                    homeController.items[index];

                                final ItemController itemController = Get.put(
                                    ItemController(
                                      item: item,
                                    ),
                                    tag: 'itemId_${item['itemId']}');

                                return ItemCard(
                                  itemController: itemController,
                                );
                              },
                            ),
                ),
              ),
            ],
          )),
    );
  }
}
