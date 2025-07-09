import 'package:flutter/material.dart';

class SpinButton extends StatelessWidget {
  const SpinButton({super.key, required this.imagePath, required this.onTap});
  final String imagePath;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        height: 50,
        width: 133,
      ),
    );
  }
}
