import 'package:flutter/material.dart';

/// A small layout helper that centers content, applies responsive
/// horizontal padding and constrains maximum width on wide screens.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      double horizontalPadding;
      double maxWidth;

      if (width < 600) {
        horizontalPadding = 16;
        maxWidth = double.infinity;
      } else if (width < 1000) {
        horizontalPadding = 24;
        maxWidth = width;
      } else {
        horizontalPadding = 48;
        maxWidth = 1100;
      }

      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
            child: child,
          ),
        ),
      );
    });
  }
}
