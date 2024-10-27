import 'package:get/get.dart';

import '../controllers/box_controller.dart';

class BoxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoxController>(
      () => BoxController(),
    );
  }
}
