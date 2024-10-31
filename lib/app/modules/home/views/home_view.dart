import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:number_scale/app/modules/home/views/widgets/menu_item.dart';
import 'package:number_scale/app/routes/app_pages.dart';
import 'package:number_scale/app/utils/constant.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MenuItem(
            name: 'Drag & Drop',
            onClick: () {
              Get.toNamed(Routes.box, arguments: {'control': Control.drag});
            },
          ),
          MenuItem(
            name: 'Radio Knob',
            onClick: () {
              Get.toNamed(Routes.box, arguments: {'control': Control.knob});
            },
          ),
          MenuItem(
            name: 'Carousel',
            onClick: () {
              Get.toNamed(Routes.box, arguments: {'control': Control.carousel});
            },
          ),
        ],
      ),
    );
  }
}
