import 'dart:math' as math;

import 'package:flutter/material.dart';

class StrippedProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double innerPadding;

  StrippedProgressPainter({
    required this.progress,
    this.progressColor = Colors.amber,
    this.backgroundColor = const Color(0xFF263238),
    this.borderColor = const Color(0xFF37474F),
    this.borderWidth = 3.0,
    this.cornerRadius = 15.0,
    this.innerPadding = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Ensure cornerRadius is not too large for the given size
    final double adjustedCornerRadius = math.min(cornerRadius, size.height / 2);

    final RRect outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(adjustedCornerRadius),
    );

    final Paint outerBackgroundPaint = Paint()
      ..color =
          const Color(0xFFDCC8A0) // Outer background color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(outerRect, outerBackgroundPaint);

    final Paint outerBorderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(outerRect, outerBorderPaint);

    // Calculate inner rectangle dimensions
    final Rect innerRect = Rect.fromLTWH(
      borderWidth + innerPadding,
      borderWidth + innerPadding,
      size.width - (borderWidth + innerPadding) * 2,
      size.height - (borderWidth + innerPadding) * 2,
    );

    // Ensure inner corner radius is valid
    final double innerCornerRadius = math.max(
      0.0,
      adjustedCornerRadius - borderWidth - innerPadding,
    );

    final RRect innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(innerCornerRadius),
    );

    final Paint innerBackgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(innerRRect, innerBackgroundPaint);

    // Calculate the width of the progress fill
    final double currentWidth = innerRect.width * progress;
    final Rect progressRect = Rect.fromLTWH(
      innerRect.left,
      innerRect.top,
      currentWidth,
      innerRect.height,
    );

    // Determine the corner radii for the progress bar, only rounding the right side if full
    final RRect progressRRect = RRect.fromRectAndCorners(
      progressRect,
      topLeft: Radius.circular(innerCornerRadius),
      bottomLeft: Radius.circular(innerCornerRadius),
      topRight: currentWidth >= innerRect.width - innerCornerRadius
          ? Radius.circular(innerCornerRadius)
          : Radius.zero,
      bottomRight: currentWidth >= innerRect.width - innerCornerRadius
          ? Radius.circular(innerCornerRadius)
          : Radius.zero,
    );

    final Paint progressPaint = Paint()..color = progressColor;
    canvas.drawRRect(progressRRect, progressPaint);

    // Calculate a darker shade of the progress color for stripes
    final Color darkerAmber = Color.alphaBlend(
      Colors.black.withOpacity(0.15),
      progressColor,
    );

    final Paint stripePaint = Paint()
      ..color = darkerAmber
      ..strokeWidth = 5.0; // Stripe thickness

    const double stripeSpacing = 5.0; // Space between stripes
    const double angle =
        -math.pi / 4; // Angle of the stripes (45 degrees downwards)

    // Save the canvas state before clipping
    canvas.save();
    // Clip the stripes to the shape of the progress bar
    canvas.clipRRect(progressRRect);

    // Draw diagonal stripes
    // Iterate from left (before the bar starts) to right (after the bar ends)
    for (
      double i =
          -size.height; // Start drawing from a point off-screen to the left/top
      i <
          size.width +
              size.height; // End drawing off-screen to the right/bottom
      i +=
          stripePaint.strokeWidth +
          stripeSpacing // Increment by stripe width + spacing
    ) {
      // Calculate start and end points for each stripe
      // The x-coordinates are offset by 'i' to create the diagonal pattern
      canvas.drawLine(
        Offset(i + progressRect.left, progressRect.top),
        Offset(
          i + progressRect.left + progressRect.height / math.tan(-angle),
          progressRect.bottom,
        ),
        stripePaint,
      );
    }
    // Restore the canvas to its state before clipping
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StrippedProgressPainter old) {
    // Repaint only if the progress value changes
    return old.progress != progress;
  }
}

class RewardProgressBarWithMilestones extends StatelessWidget {
  final int currentPoints;
  final List<int> milestones;
  final int? maxPoints;
  final double height;
  final double milestoneRadius;
  final double leftMargin; // Yeni parametre

  const RewardProgressBarWithMilestones({
    super.key,
    required this.currentPoints,
    required this.milestones,
    this.maxPoints,
    this.height = 30,
    this.milestoneRadius = 15,
    this.leftMargin = 0, // Varsayılan 0
  });

  @override
  Widget build(BuildContext context) {
    final int calculatedMaxPoints =
        maxPoints ??
        (milestones.isNotEmpty ? (milestones.last * 1.25).round() : 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Progress bar genişliği sol margini çıkararak hesaplanır
        final double barWidth = constraints.maxWidth - leftMargin;
        final double progress = (currentPoints / calculatedMaxPoints).clamp(
          0.0,
          1.0,
        );

        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Ana progress bar - sağa kaydırılmış
              Positioned(
                left: leftMargin,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: barWidth,
                  height: height,
                  child: CustomPaint(
                    painter: StrippedProgressPainter(
                      progress: progress,
                      cornerRadius: height / 2,
                    ),
                  ),
                ),
              ),

              // Milestone'ları sağa kaydırılmış alanda konumlandır
              ...milestones.map((milestone) {
                final double leftPercent = milestone / calculatedMaxPoints;
                double leftPos =
                    leftMargin + (leftPercent * barWidth) - milestoneRadius;

                final double clampedLeftPos = leftPos.clamp(
                  leftMargin,
                  leftMargin + barWidth - milestoneRadius * 2,
                );

                return Positioned(
                  left: clampedLeftPos,
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
            color: Colors.black.withOpacity(0.4),
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
          shadows: [
            Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
      ),
    );
  }
}
