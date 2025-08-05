import 'package:flutter/material.dart';
import '../theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const GlassCard({
    super.key,
    required this.child,
    this.width = 320,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withValues(alpha: 0.15),
      child: Container(
        width: width,
        height: height,
        decoration: glassmorphismCardDecoration,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
