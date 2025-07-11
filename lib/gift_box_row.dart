import 'package:flutter/material.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gray_scale_filter.dart';

class GiftBoxRow extends StatelessWidget {
  final List<int> milestones;
  final double circleRadius;
  final int currentPoints;
  final int maxPoints;
  final int collectedChests;
  const GiftBoxRow({
    super.key,
    required this.milestones,
    required this.currentPoints,
    required this.maxPoints,
    this.circleRadius = 15,
    required this.collectedChests,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth + 30;

        const double circleRadius = 15;

        const textStyle = TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

        final textSpan = TextSpan(
          text: '$collectedChests / $maxPoints',
          style: textStyle,
        );

        final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
          ..layout();

        final double textWidth = tp.width;

        final double progressWidth = totalWidth - textWidth;

        const double containerHeight = circleRadius * 2 + 16;
        final double verticalOffset = (containerHeight / 2) - (tp.height / 2);

        return SizedBox(
          height: containerHeight,
          child: _GiftBoxRowContent(
            verticalOffset: verticalOffset,
            collectedChests: collectedChests,
            textStyle: textStyle,
            maxPoints: maxPoints,
            milestones: milestones,
            currentPoints: currentPoints,
            textWidth: textWidth,
            progressWidth: progressWidth,
            circleRadius: circleRadius,
          ),
        );
      },
    );
  }
}

class _GiftBoxRowContent extends StatelessWidget {
  const _GiftBoxRowContent({
    required this.verticalOffset,
    required this.collectedChests,
    required this.textStyle,
    required this.maxPoints,
    required this.milestones,
    required this.currentPoints,
    required this.textWidth,
    required this.progressWidth,
    required this.circleRadius,
  });

  final double verticalOffset;
  final int collectedChests;
  final TextStyle textStyle;
  final int maxPoints;
  final List<int> milestones;
  final int currentPoints;
  final double textWidth;
  final double progressWidth;
  final double circleRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _PointsIndicatorText(
          verticalOffset: verticalOffset,
          collectedChests: collectedChests,
          textStyle: textStyle,
          maxPoints: maxPoints,
        ),

        ...milestones.map((milestone) {
          final milestoneReached = currentPoints >= milestone;
          final double calculatedMaxPoints = (milestones.last + 20).toDouble();
          final factor = milestone / calculatedMaxPoints;
          final centerX =
              textWidth +
              (progressWidth * factor).clamp(
                circleRadius,
                progressWidth - circleRadius,
              );
          return _ChestBoxWidget(
            centerX: centerX,
            milestoneReached: milestoneReached,
          );
        }),
      ],
    );
  }
}

class _ChestBoxWidget extends StatelessWidget {
  const _ChestBoxWidget({
    required this.centerX,
    required this.milestoneReached,
  });

  final double centerX;
  final bool milestoneReached;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: centerX - 52,
      top: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.4,
            colors: milestoneReached
                ? [Colors.white, Colors.grey]
                : [AppColors.yellow, AppColors.darkOrange],
          ),

          borderRadius: BorderRadius.circular(5),
          color: milestoneReached ? Colors.grey : AppColors.yellow,
          border: Border.all(
            color: milestoneReached ? Colors.white : AppColors.yellow,
            width: 2,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ColorFiltered(
            colorFilter: milestoneReached ? grayscaleFilter() : noFilter(),
            child: Image.asset(
              'assets/chest.png',
              fit: BoxFit.cover,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class _PointsIndicatorText extends StatelessWidget {
  const _PointsIndicatorText({
    required this.verticalOffset,
    required this.collectedChests,
    required this.textStyle,
    required this.maxPoints,
  });

  final double verticalOffset;
  final int collectedChests;
  final TextStyle textStyle;
  final int maxPoints;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Transform.translate(
        offset: Offset(0, verticalOffset),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '$collectedChests', style: textStyle),
              TextSpan(
                text: ' / $maxPoints',
                style: textStyle.copyWith(
                  fontSize: textStyle.fontSize! * 0.7,
                  color: textStyle.color?.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
