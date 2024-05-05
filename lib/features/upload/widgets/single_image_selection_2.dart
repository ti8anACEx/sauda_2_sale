import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sauda_2_sale/features/upload/controllers/push_to_sale_controller.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class SingleImageSelection2 extends StatelessWidget {
  final int index;
  SingleImageSelection2({super.key, required this.index});
  PushToSaleController pushToSaleController =
      Get.find(tag: 'push-to-sale-controller');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(
                          pushToSaleController.pushedImagesAsBytes[index],
                        ),
                        fit: BoxFit.cover)),
              )),
          const Icon(Icons.cancel).onTap(() {
            pushToSaleController.pushedImagesAsBytes.removeAt(index);
          }),
        ],
      ),
    );
  }
}
