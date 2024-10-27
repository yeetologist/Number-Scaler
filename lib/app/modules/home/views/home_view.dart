import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:number_scale/app/modules/home/views/widgets/menu_item.dart';
import 'package:number_scale/app/routes/app_pages.dart';

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            MenuItem(
              name: 'Number Box',
              onClick: () {
                Get.toNamed(Routes.BOX);
              },
            ),
          ],
        ),
      ),
    );
  }
}
