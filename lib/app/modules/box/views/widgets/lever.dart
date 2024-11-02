import 'dart:math' show pi;
import 'package:flutter/material.dart';

class AnimatedLever extends StatefulWidget {
  const AnimatedLever({super.key});

  @override
  State<AnimatedLever> createState() => _AnimatedLeverState();
}

class _AnimatedLeverState extends State<AnimatedLever>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: -(pi / 2), // 90 degrees in radians
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRotation,
      child: Stack(children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: AnimatedLeverPainter(rotationAngle: _animation.value),
              size: const Size(300, 100),
            );
          },
        ),
        CustomPaint(
          painter: StillLever(),
          size: const Size(300, 100),
        ),
      ]),
    );
  }
}

class StillLever extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()
      ..color = const Color(0xFF3c79b0)
      ..style = PaintingStyle.fill;

    final paintGreen = Paint()
      ..color = const Color(0xFF44abbc)
      ..style = PaintingStyle.fill;

    final paintGreenStroke = Paint()
      ..color = const Color.fromARGB(255, 70, 130, 140)
      ..style = PaintingStyle.fill;

    // Draw the base rectangles with rounded corners
    canvas.drawRRect(
      RRect.fromRectXY(
        Rect.fromLTWH(
          size.width * 0.7,
          size.height * -0.05,
          size.width * 0.4,
          size.height * 0.25,
        ),
        50,
        50,
      ),
      paintBlue,
    );

    // Draw the circle knob
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.1),
      30,
      paintGreenStroke,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.1),
      25,
      paintGreen,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AnimatedLeverPainter extends CustomPainter {
  final double rotationAngle;

  AnimatedLeverPainter({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    // Save the current canvas state
    canvas.save();

    // Move the canvas origin to the rotation point (where the circle is)
    canvas.translate(size.width * 0.8, size.height * 0.1);
    // Apply rotation
    canvas.rotate(rotationAngle);
    // Move the canvas back
    canvas.translate(-size.width * 0.8, -size.height * 0.1);

    final paintPink = Paint()
      ..color = const Color(0xFFb75eba)
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectXY(
        Rect.fromLTWH(
          size.width * 0.5,
          size.height * -0.05,
          size.width * 0.4,
          size.height * 0.25,
        ),
        50,
        50,
      ),
      paintPink,
    );

    // Restore the canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AnimatedLeverPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle;
  }
}
