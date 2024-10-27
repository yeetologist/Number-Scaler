import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String name;
  final Function() onClick;
  const MenuItem({super.key, required this.name, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      child: Text(name),
    );
  }
}
