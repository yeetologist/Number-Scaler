import 'package:flutter/material.dart';
import 'dart:math' as math;

class AngledScale extends StatefulWidget {
  const AngledScale({super.key});

  @override
  State<AngledScale> createState() => _AngledScaleState();
}

class _AngledScaleState extends State<AngledScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double leftWeight = 0;
  double rightWeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _updateAnimation();
  }

  void _updateAnimation() {
    double angle = (leftWeight - rightWeight) / 500;
    angle = angle.clamp(-0.3, 0.3);

    _animation = Tween<double>(
      begin: _controller.value,
      end: angle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 200,
          width: 300,
          color: Colors.lightBlue[100],
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(250, 120),
                      painter: ScalePainter(
                        angle: _animation.value,
                        leftWeight: leftWeight.toInt(),
                        rightWeight: rightWeight.toInt(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildWeightControl(
              "Left",
              leftWeight,
              (value) => setState(() {
                leftWeight = value;
                _updateAnimation();
              }),
            ),
            _buildWeightControl(
              "Right",
              rightWeight,
              (value) => setState(() {
                rightWeight = value;
                _updateAnimation();
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightControl(
      String label, double weight, ValueChanged<double> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () => onChanged(math.max(0, weight - 10)),
          child: const Icon(Icons.remove, color: Colors.white),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () => onChanged(math.min(1000, weight + 10)),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}

class ScalePainter extends CustomPainter {
  final double angle;
  final int leftWeight;
  final int rightWeight;

  ScalePainter({
    required this.angle,
    required this.leftWeight,
    required this.rightWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Save the canvas state
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    // Draw main horizontal beam
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      paint,
    );

    // Draw left support beam
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.7),
      paint,
    );

    // Draw right support beam
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.7),
      paint,
    );

    // Draw center pivot circle
    canvas.drawCircle(
      center,
      8,
      fillPaint,
    );

    // Restore canvas rotation
    canvas.restore();

    // Draw weight boxes (these don't rotate with the beam)
    _drawWeightBox(canvas, size, size.width * 0.25, size.height * 0.3,
        leftWeight.toString());
    _drawWeightBox(canvas, size, size.width * 0.75, size.height * 0.3,
        rightWeight.toString());
  }

  void _drawWeightBox(
      Canvas canvas, Size size, double x, double y, String text) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x, y), width: 60, height: 30),
      const Radius.circular(8),
    );

    final paint = Paint()..color = Colors.purple;
    canvas.drawRRect(rect, paint);

    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant ScalePainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.leftWeight != leftWeight ||
        oldDelegate.rightWeight != rightWeight;
  }
}
