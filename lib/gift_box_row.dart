import 'package:flutter/material.dart';

class GiftBoxRow extends StatelessWidget {
  final List<int> milestones;
  final double circleRadius;
  final int currentPoints;
  final int maxPoints;

  const GiftBoxRow({
    super.key,
    required this.milestones,
    required this.currentPoints,
    required this.maxPoints,
    this.circleRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;

        const double circleRadius = 15;

        final textStyle = const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

        final textSpan = TextSpan(
          text: '$currentPoints / $maxPoints',
          style: textStyle,
        );

        final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
          ..layout();

        // Yazı için gereken genişlik + biraz boşluk
        final double textWidth = tp.width;

        // Progress bar için kalan genişlik
        final double progressWidth = totalWidth - textWidth;

        final double containerHeight = circleRadius * 2 + 16;
        final double verticalOffset = (containerHeight / 2) - (tp.height / 2);

        return SizedBox(
          height: containerHeight,
          child: Stack(
            children: [
              // Yazıyı sol tarafa yerleştir
              Positioned(
                left: 0,
                top: 0,
                child: Transform.translate(
                  offset: Offset(0, verticalOffset),
                  child: Text('$currentPoints / $maxPoints', style: textStyle),
                ),
              ),

              // Kutuları sağ tarafa kaydır
              ...milestones.map((milestone) {
                final double calculatedMaxPoints = (milestones.last + 20)
                    .toDouble();
                final factor = milestone / calculatedMaxPoints;
                final centerX =
                    textWidth +
                    (progressWidth * factor).clamp(
                      circleRadius,
                      progressWidth - circleRadius,
                    );
                return Positioned(
                  left: centerX - 48,
                  top: 0,
                  child: Card(
                    color: currentPoints >= milestone
                        ? Colors.green
                        : Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.card_giftcard,
                        color: currentPoints >= milestone
                            ? Colors.white
                            : Colors.grey.shade400,
                      ),
                    ),
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
