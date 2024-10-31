import 'package:flutter/material.dart';

class NumberCarousel extends StatefulWidget {
  final List<int> numbers;
  final int initialSelected;
  final Function(int)? onNumberSelected;

  const NumberCarousel({
    super.key,
    this.numbers = const [10, 11, 12, 13, 14],
    this.initialSelected = 12,
    this.onNumberSelected,
  });

  @override
  State<NumberCarousel> createState() => _NumberCarouselState();
}

class _NumberCarouselState extends State<NumberCarousel> {
  late int selectedNumber;

  @override
  void initState() {
    super.initState();
    selectedNumber = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Triangle indicator
        CustomPaint(
          size: const Size(16, 8),
          painter: TrianglePainter(
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        // Numbers container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(colors: [
                const Color.fromARGB(255, 78, 170, 246),
                const Color.fromARGB(255, 121, 189, 244),
                const Color.fromARGB(255, 78, 170, 246)
              ])),
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: widget.numbers.map((number) {
              final isSelected = number == selectedNumber;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedNumber = number;
                    });
                    widget.onNumberSelected?.call(number);
                  },
                  child: Container(
                    width: 46,
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        number.toString(),
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.blue.shade900,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the triangle indicator
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
