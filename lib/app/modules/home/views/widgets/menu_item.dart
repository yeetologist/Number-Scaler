import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String name;
  final Function() onClick;
  const MenuItem({super.key, required this.name, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: ElevatedButton(
          onPressed: onClick,
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
