import 'package:flutter/material.dart';
import 'package:gacha/app_colors.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class GlowContainer extends StatelessWidget {
  final Color borderColor;
  final Color baseColor;
  final Widget child;

  const GlowContainer({
    required this.borderColor,
    required this.baseColor,
    required this.child,
    super.key,
    required this.isAnimated,
    required this.isHighlighted,
  });
  final bool isAnimated;
  final bool isHighlighted;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, baseColor],
          radius: 0.4,
        ),
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
        border: (isHighlighted || isAnimated)
            ? const GradientBoxBorder(
                width: 3,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.darkYellow, AppColors.darkerOrange],
                ),
              )
            : Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.7),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
