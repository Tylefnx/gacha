import 'package:flutter/material.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/game_linear_bar.dart';

class RewardProgressBarWithMilestones extends StatelessWidget {
  final int currentPoints;
  final List<int> milestones;
  final double height;
  final double milestoneRadius;

  const RewardProgressBarWithMilestones({
    super.key,
    required this.currentPoints,
    required this.milestones,
    this.height = 23,
    this.milestoneRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth;
        const double offsetFactor =
            0.1; // Bar ve mihenk taşlarının başlangıç ofseti
        final double maxProgressValue = milestones.last * 1.25;

        // İlerleme yüzdesi, ofset faktörü ile birlikte
        final double progressPercent =
            (currentPoints / maxProgressValue).clamp(0.0, 1.0) + offsetFactor;

        return SizedBox(
          height: height,
          width: barWidth,
          child: Stack(
            clipBehavior: Clip.none, // Çocukların dışarı taşmasına izin verir
            children: [
              // İlerleme çubuğu
              Positioned(
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: barWidth,
                  height: height,
                  child: GameLinearBar.yellow(
                    width: barWidth,
                    height: height,
                    percent: progressPercent,
                  ),
                ),
              ),
              // Mihenk taşı daireleri
              ...milestones.map((milestone) {
                // Mihenk taşının çubuk üzerindeki orantılı konumu
                final double milestonePositionFactor =
                    milestone / maxProgressValue;
                // Mihenk taşının mutlak yatay konumu (ofset faktörü dahil)
                final double actualLeftPosition =
                    (barWidth * milestonePositionFactor) +
                    (barWidth * offsetFactor);

                return Positioned(
                  left:
                      actualLeftPosition -
                      milestoneRadius, // Daireyi merkeze hizala
                  top: (height / 2) - milestoneRadius, // Daireyi dikeyde ortala
                  child: _BuildMilestoneCircle(
                    milestone: milestone,
                    reached: currentPoints >= milestone,
                    radius: milestoneRadius,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _BuildMilestoneCircle extends StatelessWidget {
  final int milestone;
  final bool reached;
  final double radius;

  const _BuildMilestoneCircle({
    required this.milestone,
    required this.reached,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: reached ? AppColors.darkYellow : Colors.grey.shade700,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black87, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        milestone.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2)],
        ),
      ),
    );
  }
}
