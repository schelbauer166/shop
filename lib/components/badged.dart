import 'package:flutter/material.dart';

class Badgedd extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;
  const Badgedd({
    super.key,
    required this.child,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 8,
          top: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary,
            ),
            constraints: const BoxConstraints(
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
