import 'package:flutter/material.dart';
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
        final double offset = barWidth * 0.1;
        final double progress =
            (currentPoints / (milestones.last * 1.25)) + 0.1;

        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: barWidth,
                  height: height,
                  child: GameLinearBar.yellow(
                    width: barWidth,
                    height: height,
                    percent: progress,
                  ),
                ),
              ),

              ...milestones.map((milestone) {
                return Positioned(
                  left:
                      ((barWidth * (milestone / (milestones.last * 1.25))) -
                          milestoneRadius) +
                      offset,
                  top: (height / 2) - milestoneRadius,
                  child: _buildMilestoneCircle(
                    milestone,
                    currentPoints >= milestone,
                    milestoneRadius,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMilestoneCircle(int milestone, bool reached, double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: reached ? Colors.amber : Colors.grey.shade700,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black87, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: Offset(0, 2),
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
          shadows: [
            Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
      ),
    );
  }
}
