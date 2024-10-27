import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:number_scale/app/global_widgets/number_box.dart';
import 'package:number_scale/app/global_widgets/scale_painter.dart';

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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: [
            CustomPaint(
              painter: ScalePainter(),
              size: Size(400, 580),
            ),
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
                        feedback: NumberBox(number: item),
                        child: NumberBox(number: item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
