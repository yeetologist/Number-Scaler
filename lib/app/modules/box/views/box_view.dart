import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:number_scale/app/modules/box/views/widgets/box.dart';
import 'package:number_scale/app/modules/box/views/widgets/knob.dart';
import 'package:number_scale/app/modules/box/views/widgets/scale.dart';
import 'package:number_scale/app/utils/constant.dart';

import 'widgets/carousel.dart';
import 'widgets/lever.dart';
import '../controllers/box_controller.dart';

class BoxView extends GetView<BoxController> {
  const BoxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BoxView'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                controller.reset();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: [
            // GetBuilder<BoxController>(
            //   builder: (controller) =>
            //       _buildDragTarget(controller.leftWeight.value),
            // ),
            Spacer(),
            GetBuilder<BoxController>(
              id: 'scale',
              builder: (_) => DragTarget<int>(
                builder: (context, candidateData, rejectedData) =>
                    DoubleNumberScale(
                  isSingleInput: controller.arguments['control'] == Control.drag
                      ? false
                      : true,
                  leftWeight: controller.getLeftWeight,
                  rightWeight: controller.getRightWeight,
                  rightSecondWeight: controller.getRightSecondWeight,
                ),
                onWillAcceptWithDetails: (details) {
                  if (controller.dropOrder % 2 == 1) {
                    controller.setRightWeight = details.data;
                  } else {
                    controller.setRightSecondWeight = details.data;
                  }
                  controller.dropOrder++;
                  return true;
                },
              ),
            ),

            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AnimatedLever(),
            ),

            if (controller.arguments['control'] == Control.drag)
              Container(
                color: const Color(0xFF8eb6c9),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...controller.choices.map(
                        (item) => Draggable<int>(
                          data: item,
                          feedback: NumberBox(number: item),
                          childWhenDragging: NumberBox(number: 0),
                          child: NumberBox(number: item),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (controller.arguments['control'] == Control.knob)
              Container(
                color: const Color(0xFF8eb6c9),
                padding: EdgeInsets.symmetric(vertical: 12),
                width: Get.size.width,
                child: Center(
                  child: GetBuilder<BoxController>(
                    builder: (_) => NumberKnob(
                      value: controller.rightSecondWeight.value,
                      isLeftPressed: (value) {
                        if (value == true) {
                          controller.addLeft();
                        } else {
                          controller.addRight();
                        }
                      },
                    ),
                  ),
                ),
              ),

            if (controller.arguments['control'] == Control.carousel)
              Container(
                color: const Color(0xFF8eb6c9),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 100,
                  child: CarouselExample(
                    onMiddleItemChanged: (value) {
                      controller.setRightSecondWeight = value;
                    },
                  ),
                ),
              ),
          ]),
        ));
  }
}
