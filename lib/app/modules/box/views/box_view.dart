import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/box_controller.dart';

class BoxView extends GetView<BoxController> {
  const BoxView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BoxView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BoxView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
