import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class KnobPainter extends CustomPainter {
  final bool isLeftPressed;
  final bool isRightPressed;

  KnobPainter({
    this.isLeftPressed = false,
    this.isRightPressed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.2; // Main knob size

    // Paint for the main circular knob
    final knobPaint = Paint()
      ..color = Colors.blue[200]!
      ..style = PaintingStyle.fill;

    // Paint for the border
    final borderPaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw serrated edge for the knob
    final serratedPath = Path();
    final serratedRadius = radius * 1.15;
    final numTeeth = 20;
    final teethDepth = radius * 0.2;

    for (int i = 0; i <= numTeeth; i++) {
      final angle = (i / numTeeth) * 2 * math.pi;
      final nextAngle = ((i + 1) / numTeeth) * 2 * math.pi;

      // Calculate current point
      final outerRadius = serratedRadius + (i % 2 == 0 ? teethDepth : 0);
      final x = center.dx + outerRadius * math.cos(angle);
      final y = center.dy + outerRadius * math.sin(angle);

      // Calculate next point
      final nextOuterRadius =
          serratedRadius + ((i + 1) % 2 == 0 ? teethDepth : 0);
      final nextX = center.dx + nextOuterRadius * math.cos(nextAngle);
      final nextY = center.dy + nextOuterRadius * math.sin(nextAngle);

      if (i == 0) {
        serratedPath.moveTo(x, y);
      } else {
        // Calculate two control points for the cubic curve
        final third = (nextAngle - angle) / 3;

        final control1X = center.dx + outerRadius * math.cos(angle + third);
        final control1Y = center.dy + outerRadius * math.sin(angle + third);

        final control2X =
            center.dx + nextOuterRadius * math.cos(nextAngle - third);
        final control2Y =
            center.dy + nextOuterRadius * math.sin(nextAngle - third);

        // Add cubic bezier curve
        serratedPath.cubicTo(
            control1X, control1Y, control2X, control2Y, nextX, nextY);
      }
    }
    serratedPath.close();

    // Draw the serrated knob
    canvas.drawPath(serratedPath, knobPaint);
    canvas.drawPath(serratedPath, borderPaint);

    // Draw center dot
    canvas.drawCircle(
      center,
      radius * 0.1,
      Paint()..color = Colors.blue[300]!,
    );

    // Draw left triangle
    final leftTrianglePath = Path();
    final leftTriangleCenter = Offset(size.width * 0.1, center.dy);
    final triangleSize = size.width * 0.1;

    leftTrianglePath.moveTo(leftTriangleCenter.dx - triangleSize, center.dy);
    leftTrianglePath.lineTo(
        leftTriangleCenter.dx + triangleSize, center.dy - triangleSize);
    leftTrianglePath.lineTo(
        leftTriangleCenter.dx + triangleSize, center.dy + triangleSize);
    leftTrianglePath.close();

    // Draw right triangle
    final rightTrianglePath = Path();
    final rightTriangleCenter = Offset(size.width * 0.9, center.dy);

    rightTrianglePath.moveTo(rightTriangleCenter.dx + triangleSize, center.dy);
    rightTrianglePath.lineTo(
        rightTriangleCenter.dx - triangleSize, center.dy - triangleSize);
    rightTrianglePath.lineTo(
        rightTriangleCenter.dx - triangleSize, center.dy + triangleSize);
    rightTrianglePath.close();

    // Draw triangles with different colors based on press state
    canvas.drawPath(
      leftTrianglePath,
      Paint()..color = isLeftPressed ? Colors.blue[400]! : Colors.blue[300]!,
    );
    canvas.drawPath(
      rightTrianglePath,
      Paint()..color = isRightPressed ? Colors.blue[400]! : Colors.blue[300]!,
    );

    final iconAdd = Icons.add;
    final iconMinus = Icons.minimize;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconAdd.codePoint),
        style: TextStyle(fontSize: 30.0, fontFamily: iconAdd.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.79, center.dy - 15));
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconMinus.codePoint),
        style: TextStyle(fontSize: 30.0, fontFamily: iconAdd.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.05, center.dy - 25));
  }

  @override
  bool shouldRepaint(covariant KnobPainter oldDelegate) {
    return oldDelegate.isLeftPressed != isLeftPressed ||
        oldDelegate.isRightPressed != isRightPressed;
  }
}

class NumberKnob extends StatefulWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final ValueChanged<bool>? isLeftPressed;
  final int min;
  final int max;
  final int step;

  const NumberKnob({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 1000,
    this.step = 1,
    this.isLeftPressed,
  });

  @override
  State<NumberKnob> createState() => _NumberKnobState();
}

class _NumberKnobState extends State<NumberKnob> {
  bool isLeftPressed = false;
  bool isRightPressed = false;
  Timer? _timer;

  void _startDecreasing() {
    setState(() => isLeftPressed = true);
    _updateValue(-widget.step);
  }

  void _startIncreasing() {
    setState(() => isRightPressed = true);
    _updateValue(widget.step);
  }

  void _stopChanging() {
    _timer?.cancel();
    setState(() {
      isLeftPressed = false;
      isRightPressed = false;
    });
  }

  void _updateValue(int change) {
    final newValue = (widget.value + change).clamp(widget.min, widget.max);
    widget.isLeftPressed?.call(isLeftPressed);
    widget.onChanged?.call(newValue);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(200, 100),
            painter: KnobPainter(
              isLeftPressed: isLeftPressed,
              isRightPressed: isRightPressed,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 60,
            child: GestureDetector(
              onTapDown: (_) => _startDecreasing(),
              onTapUp: (_) => _stopChanging(),
              onTapCancel: _stopChanging,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 60,
            child: GestureDetector(
              onTapDown: (_) => _startIncreasing(),
              onTapUp: (_) => _stopChanging(),
              onTapCancel: _stopChanging,
            ),
          ),
        ],
      ),
    );
  }
}
