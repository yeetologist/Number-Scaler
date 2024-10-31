import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  final int number;
  final double width;
  final double height;

  const NumberBox({
    super.key,
    required this.number,
    this.width = 80,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey, // Gray color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 65, 65, 65),
            // blurRadius: 4,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toStringAsFixed(0),
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
