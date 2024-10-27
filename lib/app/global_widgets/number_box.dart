import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  final int number;
  final double width;
  final double height;

  const NumberBox({
    super.key,
    required this.number,
    this.width = 80,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey, // Gray color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            // blurRadius: 4,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
