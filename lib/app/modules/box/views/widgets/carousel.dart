import 'package:flutter/material.dart';

class CarouselExample extends StatefulWidget {
  final ValueChanged<int>? onMiddleItemChanged;
  const CarouselExample({super.key, this.onMiddleItemChanged});

  @override
  State<CarouselExample> createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  final itemExtent = 90.0;
  final double itemWidth = 90.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Get the scroll position and viewport dimensions
    final ScrollPosition position = _scrollController.position;
    final double scrollOffset = position.pixels;
    final double viewportWidth = position.viewportDimension;

    // Calculate the center point of the viewport
    final double centerOffset = scrollOffset + (viewportWidth / 2);

    // Calculate which item is at the center
    int centerIndex = (centerOffset / itemWidth).round();

    if (centerIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = centerIndex;
      });
      widget.onMiddleItemChanged?.call(centerIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomPaint(
            size: const Size(30, 20),
            painter: TrianglePainter(color: Colors.blue),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 60),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemExtent: itemExtent,
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return UncontainedLayoutCard(
                      index: index,
                      label: '$index',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
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
      ..moveTo(size.width / 2, size.height) // Move to the bottom center
      ..lineTo(0, 0) // Draw line to top left
      ..lineTo(size.width, 0) // Draw line to top right
      ..close(); // Close the path to form the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
