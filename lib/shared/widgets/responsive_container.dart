import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > maxWidth;

    if (isWideScreen) {
      return Center(
        child: SizedBox(
          width: maxWidth,
          child: child,
        ),
      );
    }

    return child;
  }
}

