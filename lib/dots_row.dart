// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

class DotsRow extends StatelessWidget {
  final List<Widget> children;

  const DotsRow._({required this.children});

  factory DotsRow.lightThenPlain({int count = 6}) {
    return DotsRow._(
      children: List.generate(
        count,
        (i) => i.isEven ? ShiningDot.light() : ShiningDot.plain(),
      ),
    );
  }

  factory DotsRow.plainThenLight({int count = 6}) {
    return DotsRow._(
      children: List.generate(
        count,
        (i) => i.isEven ? ShiningDot.plain() : ShiningDot.light(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}

class ShiningDot extends StatelessWidget {
  final Color color;
  final double size;
  final double? blurRadius;
  final double? spreadRadius;
  final double? opacity;
  final bool _hasShadow;

  const ShiningDot._({
    super.key,
    required this.color,
    this.size = 7.5,
    this.blurRadius,
    this.spreadRadius,
    this.opacity,
    required bool hasShadow,
  }) : _hasShadow = hasShadow;

  factory ShiningDot.light({
    Key? key,
    Color color = Colors.white,
    double blurRadius = 7.5,
    double spreadRadius = 3,
    double opacity = 0.6,
  }) {
    return ShiningDot._(
      key: key,
      color: color,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      opacity: opacity,
      hasShadow: true,
    );
  }

  factory ShiningDot.plain({Key? key, Color color = Colors.white}) {
    return ShiningDot._(key: key, color: color, hasShadow: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: _hasShadow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: opacity ?? 0.6),
                  blurRadius: blurRadius ?? 10,
                  spreadRadius: spreadRadius ?? 3,
                ),
              ]
            : null,
      ),
    );
  }
}
