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
        const double offset = 0.1;
        final double progress =
            (currentPoints / (milestones.last * 1.25)) + offset;

        final createdMileStoneCircles = milestones.map((milestone) {
          return Positioned(
            left:
                ((barWidth * (milestone / (milestones.last * 1.25))) -
                    milestoneRadius) +
                barWidth * offset,
            top: (height / 2) - milestoneRadius,
            child: _BuildMilestoneCircle(
              milestone: milestone,
              reached: currentPoints >= milestone,
              radius: milestoneRadius,
            ),
          );
        });
        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                child: _ChestRewardProgressBar(
                  barWidth: barWidth,
                  height: height,
                  progress: progress,
                ),
              ),
              ...createdMileStoneCircles,
            ],
          ),
        );
      },
    );
  }
}

class _ChestRewardProgressBar extends StatelessWidget {
  const _ChestRewardProgressBar({
    required this.barWidth,
    required this.height,
    required this.progress,
  });

  final double barWidth;
  final double height;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      height: height,
      child: GameLinearBar.yellow(
        width: barWidth,
        height: height,
        percent: progress,
      ),
    );
  }
}

class _BuildMilestoneCircle extends StatelessWidget {
  const _BuildMilestoneCircle({
    required this.milestone,
    required this.reached,
    required this.radius,
  });
  final int milestone;
  final bool reached;
  final double radius;

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
