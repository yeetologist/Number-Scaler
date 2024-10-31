import 'dart:math';

import 'package:get/get.dart';
import 'package:number_scale/app/utils/constant.dart';

class BoxController extends GetxController {
  final Map<int, bool> score = {};
  final random = Random();
  final List<int> choices = [];
  final leftWeight = 0.obs;
  final rightWeight = 0.obs;
  final rightSecondWeight = 0.obs;
  final arguments = Get.arguments;
  int dropOrder = 1;

  int get getLeftWeight {
    return leftWeight.value;
  }

  int get getRightWeight {
    return rightWeight.value;
  }

  int get getRightSecondWeight {
    return rightSecondWeight.value;
  }

  set setLeftWeight(int newValue) {
    leftWeight.value = newValue;
    update(['scale']);
  }

  set setRightWeight(int newValue) {
    rightWeight.value = newValue;
    update(['scale']);
  }

  set setRightSecondWeight(int newValue) {
    rightSecondWeight.value = newValue;
    update(['scale']);
  }

  void submit(bool isSingleInput) {
    if (isSingleInput) {
      setRightSecondWeight = 0;
    } else {
      rightWeight.value = 0;
      rightSecondWeight.value = 0;
    }
    update(['scale', 'lever']);
  }

  void reset(bool isSingleInput) {
    if (isSingleInput) {
      setRightSecondWeight = 0;
    } else {
      rightWeight.value = 0;
      rightSecondWeight.value = 0;
    }
    update(['scale', 'lever']);
  }

  @override
  void onInit() {
    super.onInit();
    if (arguments['control'] == Control.drag) {
      for (int i = 0; i < 6; i++) {
        choices.add(random.nextInt(100) + 1);
      }
      setLeftWeight = choices[random.nextInt(5)] * choices[random.nextInt(5)];
    } else {
      for (int i = 0; i < 2; i++) {
        choices.add(random.nextInt(10) + 1);
      }
      setLeftWeight = choices[0];
      setRightWeight = choices[1];
    }
  }
}
