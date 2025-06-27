// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

class DotsRow extends StatelessWidget {
  final List<Widget> children;

  const DotsRow._({required this.children});

  factory DotsRow.lightThenPlain({int count = 6}) {
    final List<Widget> dots = [];
    for (int i = 0; i < count; i++) {
      if (i.isEven) {
        dots.add(ShiningDot.light());
      } else {
        dots.add(ShiningDot.plain());
      }
    }
    return DotsRow._(children: dots);
  }

  factory DotsRow.plainThenLight({int count = 6}) {
    final List<Widget> dots = [];
    for (int i = 0; i < count; i++) {
      if (i.isEven) {
        dots.add(ShiningDot.plain());
      } else {
        dots.add(ShiningDot.light());
      }
    }
    return DotsRow._(children: dots);
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
  final bool _isLight;

  const ShiningDot._({
    super.key,
    required this.color,
    this.size = 7.5,
    this.blurRadius,
    this.spreadRadius,
    this.opacity,
    required bool isLight,
  }) : _isLight = isLight;

  /// Işıklı (parlayan) bir nokta oluşturur.
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
      isLight: true,
    );
  }

  factory ShiningDot.plain({Key? key, Color color = Colors.white}) {
    return ShiningDot._(key: key, color: color, isLight: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: _isLight
            ? [
                BoxShadow(
                  color: color.withValues(alpha: opacity ?? 0.6),
                  blurRadius: blurRadius ?? 10,
                  spreadRadius: spreadRadius ?? 3,
                ),
              ]
            : null, // Işıksız ise boxShadow olmasın
      ),
    );
  }
}
