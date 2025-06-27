import 'package:flutter/material.dart';

class GameLinearBar extends StatefulWidget {
  final double height;
  final double width;
  final double percent;
  final LinearGradient color;
  final Color borderColor;
  final Widget? center;
  const GameLinearBar({
    super.key,
    required this.height,
    required this.width,
    required this.percent,
    required this.color,
    required this.borderColor,
    this.center,
  });

  factory GameLinearBar.green({
    required double width,
    required double height,
    required double percent,
    Widget? center,
  }) => GameLinearBar(
    width: width,
    height: height,
    percent: percent,
    center: center,
    color: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF7FD97A), Color(0xFF42B23C)],
    ),
    borderColor: const Color(0xFF42B23C),
  );
  factory GameLinearBar.red({
    required double width,
    required double height,
    required double percent,
    Widget? center,
  }) => GameLinearBar(
    width: width,
    height: height,
    percent: percent,
    center: center,
    color: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE98080), Color(0xFFEF3B19)],
    ),
    borderColor: const Color(0xFFEF3B19),
  );

  factory GameLinearBar.yellow({
    required double width,
    required double height,
    required double percent,
    Widget? center,
  }) => GameLinearBar(
    width: width,
    height: height,
    percent: percent,
    center: center,
    color: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF2E294), Color(0xFFEFB919)],
    ),
    borderColor: const Color(0xFFEFB919),
  );

  factory GameLinearBar.percent({
    required double width,
    required double height,
    required double percent,
    Widget? center,
    bool reverse = false,
  }) {
    if (reverse) {
      if (percent <= 0.33) {
        return GameLinearBar.red(
          width: width,
          height: height,
          percent: percent,
          center: center,
        );
      } else if (percent <= 0.66) {
        return GameLinearBar.yellow(
          width: width,
          height: height,
          percent: percent,
          center: center,
        );
      } else {
        return GameLinearBar.green(
          width: width,
          height: height,
          percent: percent,
          center: center,
        );
      }
    } else {
      if (percent <= 0.75) {
        return GameLinearBar.green(
          width: width,
          height: height,
          percent: percent,
          center: center,
        );
      } else if (percent <= 0.9) {
        return GameLinearBar.yellow(
          width: width,
          height: height,
          percent: percent,
          center: center,
        );
      } else {
        return GameLinearBar.red(
          width: width,
          height: height,
          percent: percent,
          center: center,
        );
      }
    }
  }

  @override
  State<GameLinearBar> createState() => _GameLinearBarState();
}

class _GameLinearBarState extends State<GameLinearBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.borderColor),
      ),
      child: Container(
        width: widget.width - 1,
        height: widget.height - 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(),
          color: widget.borderColor.withValues(alpha: 0.1),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: widget.height - 5,
                  width: widget.width * widget.percent,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: widget.height - 5,
                          width: widget.width * widget.percent,
                          decoration: BoxDecoration(gradient: widget.color),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Row(
                          children: List.generate(
                            14,
                            (index) => Transform(
                              transform: Matrix4.skew(-0.8, 0.0),
                              child: Container(
                                height: widget.height - 6,
                                width: 6,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.09),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(child: widget.center),
          ],
        ),
      ),
    );
  }
}
