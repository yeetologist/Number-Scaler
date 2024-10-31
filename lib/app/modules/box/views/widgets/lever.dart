import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedLever extends StatefulWidget {
  final bool isToggled;
  final Duration duration;

  const AnimatedLever({
    super.key,
    this.isToggled = false,
    this.duration = const Duration(milliseconds: 300),
  });

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
      duration: widget.duration,
      vsync: this,
    );

    _animation =
        Tween<double>(begin: 0, end: 90 * pi / 180).animate(_controller);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void didUpdateWidget(AnimatedLever oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isToggled) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.rotate(
            angle: _animation.value,
            child: CustomPaint(
              painter: AnimatedLeverPainter(
                isToggled: widget.isToggled,
              ),
              size: const Size(200, 100),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedLeverPainter extends CustomPainter {
  final bool isToggled;

  AnimatedLeverPainter({
    required this.isToggled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintPink = Paint()
      ..color = const Color(0xFFb75eba)
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    final paintGreen = Paint()
      ..color = const Color(0xFF44abbc)
      ..style = PaintingStyle.fill;

    final paintGreenStroke = Paint()
      ..color = const Color.fromARGB(255, 70, 130, 140)
      ..style = PaintingStyle.fill;

    final paintBlue = Paint()
      ..color = const Color(0xFF3c79b0)
      ..style = PaintingStyle.fill;

    // Calculate positions based on animation progress
    // final startX = size.width * 0.7;
    // final endX = size.width * 0.7;
    // final currentX = startX + (endX - startX) * progress;

    // Draw the base rectangles with rounded corners
    canvas.drawRRect(
      RRect.fromRectXY(
        Rect.fromLTWH(
          size.width * 0.7,
          size.height * 0,
          size.width * 0.4,
          size.height * 0.2,
        ),
        50,
        50,
      ),
      paintBlue,
    );

    canvas.drawRRect(
      RRect.fromRectXY(
        Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0,
          size.width * 0.4,
          size.height * 0.2,
        ),
        50,
        50,
      ),
      paintPink,
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
  bool shouldRepaint(covariant AnimatedLeverPainter oldDelegate) {
    return oldDelegate.isToggled != isToggled;
  }
}
