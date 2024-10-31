import 'package:flutter/material.dart';

class NumberScale extends StatefulWidget {
  final int leftWeight;
  final int rightWeight;
  final int rightSecondWeight;
  final bool isSingleInput;

  const NumberScale({
    super.key,
    this.leftWeight = 0,
    this.rightWeight = 0,
    this.rightSecondWeight = 0,
    this.isSingleInput = true,
  });

  @override
  State<NumberScale> createState() => _NumberScaleState();
}

class _NumberScaleState extends State<NumberScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _updateAnimation();
    _animation.addListener(() {
      currentAngle = _animation.value;
    });
  }

  void _updateAnimation() {
    // Calculate rotation based on weight difference
    double angle = _calculateAngle(widget.isSingleInput);
    // Limit the rotation to prevent extreme angles
    angle = angle.clamp(-0.3, 0.3);

    _animation = Tween<double>(
      begin: currentAngle,
      end: angle * -1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.forward(from: 0);
  }

  double _calculateAngle(bool isSingleInput) {
    if (isSingleInput) {
      return ((widget.leftWeight * widget.rightWeight) -
              widget.rightSecondWeight) /
          500;
    } else {
      return (widget.leftWeight -
              (widget.rightWeight * widget.rightSecondWeight)) /
          500;
    }
  }

  @override
  void didUpdateWidget(NumberScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leftWeight != widget.leftWeight ||
        oldWidget.rightWeight != widget.rightWeight ||
        oldWidget.rightSecondWeight != widget.rightSecondWeight) {
      _updateAnimation();
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
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: CustomPaint(
            size: const Size(400, 400),
            painter: ScalePainter(
              currentAngle: currentAngle,
              isSingleInput: widget.isSingleInput,
              leftWeight: widget.leftWeight,
              rightWeight: widget.rightWeight,
              rightSecondWeight: widget.rightSecondWeight,
            ),
          ),
        );
      },
    );
  }
}

class ScalePainter extends CustomPainter {
  final bool isSingleInput;
  final int leftWeight;
  final int rightWeight;
  final int rightSecondWeight;
  final double currentAngle;

  ScalePainter(
      {this.isSingleInput = true,
      this.currentAngle = 0,
      this.leftWeight = 0,
      this.rightWeight = 0,
      this.rightSecondWeight = 0});

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
      20,
      paintLightStroke,
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      16,
      paintDeep,
    );

    //PILLAR LEFT
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.12, size.height * 0.25, 60, 30),
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

    //PLACEHOLDER LEFT
    _drawPlaceholder(canvas, size, paintLightFill, paintDeep, size.width * 0,
        size.height * 0.07);

    //PILLAR RIGHT
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.73, size.height * 0.25, 60, 30),
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
    _drawPlaceholder(canvas, size, paintLightFill, paintDeep, size.width * 0.61,
        size.height * 0.07);

    // Draw the weight numbers
    _drawWeightBox(canvas, size, isSingleInput, currentAngle);
    _drawWeightText(canvas, size, "\u00D7", 0, isSingleInput);
    _drawWeightText(
        canvas, size, leftWeight.toStringAsFixed(0), 1, isSingleInput);
    _drawWeightText(
        canvas, size, rightWeight.toStringAsFixed(0), 2, isSingleInput);
    _drawWeightText(
        canvas, size, rightSecondWeight.toStringAsFixed(0), 3, isSingleInput);
  }

  void _drawWeightBox(
      Canvas canvas, Size size, bool isSingleInput, double currentAngle) {
    if (isSingleInput) {
      if (currentAngle != 0) {
        // Single Input Wrong
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.085,
                size.width * 0.365, size.height * 0.17),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[700]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.09,
                size.width * 0.38, size.height * 0.178),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[700]!
            ..style = PaintingStyle.fill,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.085,
                size.width * 0.365, size.height * 0.17),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[300]!
            ..style = PaintingStyle.fill,
        );
      } else {
        // Single Input Correct
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.085,
                size.width * 0.365, size.height * 0.17),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[700]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.633, size.height * 0.09,
                size.width * 0.365, size.height * 0.175),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[700]!
            ..style = PaintingStyle.fill,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.085,
                size.width * 0.365, size.height * 0.17),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[300]!
            ..style = PaintingStyle.fill,
        );
      }
    } else {
      if (currentAngle != 0) {
        // Double Input Wrong
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.63, size.height * 0.1,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[700]!
            ..style = PaintingStyle.fill,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.85, size.height * 0.1,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[700]!
            ..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[300]!
            ..style = PaintingStyle.fill,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.84, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[300]!
            ..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[700]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.84, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.red[700]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      } else {
        // Double Input Correct
        canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(size.width * 0.63, size.height * 0.1,
                  size.width * 0.15, size.height * 0.16),
              const Radius.circular(10),
            ),
            Paint()
              ..color = Colors.green[700]!
              ..style = PaintingStyle.fill);

        canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(size.width * 0.84, size.height * 0.1,
                  size.width * 0.15, size.height * 0.16),
              const Radius.circular(10),
            ),
            Paint()
              ..color = Colors.green[700]!
              ..style = PaintingStyle.fill);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[300]!
            ..style = PaintingStyle.fill,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.83, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[300]!
            ..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.62, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[700]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.83, size.height * 0.09,
                size.width * 0.15, size.height * 0.16),
            const Radius.circular(10),
          ),
          Paint()
            ..color = Colors.green[700]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  void _drawWeightText(Canvas canvas, Size size, String text, int numberOrder,
      bool isSingleInput) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    if (isSingleInput == true) {
      if (numberOrder == 0) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.17 - textPainter.width / 2, size.height * 0.12),
        );
      } else if (numberOrder == 1) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.07 - textPainter.width / 2, size.height * 0.12),
        );
      } else if (numberOrder == 2) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.27 - textPainter.width / 2, size.height * 0.12),
        );
      } else {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.8 - textPainter.width / 2, size.height * 0.12),
        );
      }
    } else {
      if (numberOrder == 0) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.81 - textPainter.width / 2, size.height * 0.12),
        );
      } else if (numberOrder == 1) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.19 - textPainter.width / 2, size.height * 0.13),
        );
      } else if (numberOrder == 2) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.69 - textPainter.width / 2, size.height * 0.12),
        );
      } else {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.9 - textPainter.width / 2, size.height * 0.12),
        );
      }
    }
  }

  void _drawPlaceholder(Canvas canvas, Size size, Paint paintLight,
      Paint paintDeep, double left, double top) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 6, top + 6, size.width * 0.4, size.height * 0.20),
        const Radius.circular(10),
      ),
      paintDeep,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, size.width * 0.4, size.height * 0.20),
        const Radius.circular(10),
      ),
      paintLight,
    );
  }

  @override
  bool shouldRepaint(covariant ScalePainter oldDelegate) {
    return oldDelegate.leftWeight != leftWeight ||
        oldDelegate.rightWeight != rightWeight ||
        oldDelegate.rightSecondWeight != rightSecondWeight;
  }
}
