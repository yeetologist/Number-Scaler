import 'package:flutter/material.dart';

class ScalePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double bulbRadius = 20;
    final paintLightStroke = Paint()
      ..color = const Color(0xFF582c97)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final paintLightFill = Paint()
      ..color = const Color(0xFF582c97)
      ..style = PaintingStyle.fill;

    final paintDeep = Paint()
      ..color = const Color(0xFF341067)
      ..style = PaintingStyle.fill;

    //BASE
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromLTRB(size.width * 0.1, size.height * 0.48,
                size.width * 0.9, size.height * 0.52),
            50,
            50),
        paintDeep);

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      20, // radius
      paintLightStroke,
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      16, // radius
      paintDeep,
    );

    //PLACEHOLDER LEFT
    drawPlaceholder(canvas, size, paintLightFill, paintDeep, size.width * 0,
        size.height * 0.15);

    //PILLAR LEFT
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.12, size.height * 0.28, 60, 30),
        paintDeep);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.17, size.height * 0.3, bulbRadius,
              size.height * 0.3),
          const Radius.circular(10),
        ),
        paintLightFill);

    canvas.drawCircle(Offset(size.width * 0.195, size.height * 0.57),
        bulbRadius, paintLightFill);

    //PILLAR RIGHT
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.73, size.height * 0.28, 60, 30),
        paintDeep);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.78, size.height * 0.3, bulbRadius,
              size.height * 0.3),
          const Radius.circular(10),
        ),
        paintLightFill);

    canvas.drawCircle(Offset(size.width * 0.805, size.height * 0.57),
        bulbRadius, paintLightFill);

    //PLACEHOLDER RIGHT
    drawPlaceholder(canvas, size, paintLightFill, paintDeep, size.width * 0.61,
        size.height * 0.15);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawPlaceholder(Canvas canvas, Size size, Paint paintLight,
      Paint paintDeep, double left, double top) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 6, top + 6, size.width * 0.38, size.height * 0.12),
        const Radius.circular(10),
      ),
      paintDeep,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, size.width * 0.38, size.height * 0.12),
        const Radius.circular(10),
      ),
      paintLight,
    );
  }

  void drawPillar() {}
}
