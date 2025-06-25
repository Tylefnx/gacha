import 'dart:math' as math;
import 'package:flutter/material.dart';

class StrippedProgressPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0 arası ilerleme oranı
  final Color progressColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double innerPadding; // Kenarlık ile iç kısım arasındaki boşluk

  StrippedProgressPainter({
    required this.progress,
    this.progressColor = Colors.amber, // Ana ilerleme rengi sarı
    this.backgroundColor = const Color(0xFF263238), // Koyu arka plan rengi
    this.borderColor = const Color(0xFF37474F), // Dış çerçevenin koyu kenarlığı
    this.borderWidth = 3.0,
    this.cornerRadius = 15.0,
    this.innerPadding = 2.0, // İçteki boşluk (resimdeki gibi)
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(cornerRadius),
    );

    // 1. Dış Çerçeve Arka Planı (Açık Kahverengi/Bej)
    final Paint outerBackgroundPaint = Paint()
      ..color =
          const Color(0xFFDCC8A0) // Açık kahverengi/bej
      ..style = PaintingStyle.fill;
    canvas.drawRRect(outerRect, outerBackgroundPaint);

    // 2. Dış Çerçeve Kenarlığı (Koyu Renk)
    final Paint outerBorderPaint = Paint()
      ..color =
          borderColor // Koyu renkli kenarlık
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(outerRect, outerBorderPaint);

    // 3. İç İlerleme Alanı (Arka Plan - Koyu Gri/Siyah)
    final Rect innerRect = Rect.fromLTWH(
      borderWidth + innerPadding,
      borderWidth + innerPadding,
      size.width - (borderWidth + innerPadding) * 2,
      size.height - (borderWidth + innerPadding) * 2,
    );
    final RRect innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(
        cornerRadius - borderWidth - innerPadding,
      ), // İç köşeyi dışa göre ayarla
    );
    final Paint innerBackgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(innerRRect, innerBackgroundPaint);

    // 4. İlerleyen Kısım (Sarı ve Çizgili)
    final double currentWidth = innerRect.width * progress;
    final Rect progressRect = Rect.fromLTWH(
      innerRect.left,
      innerRect.top,
      currentWidth,
      innerRect.height,
    );
    // Sol tarafı oval, sağ tarafı düz (ilerlemeye göre değişir)
    final RRect progressRRect = RRect.fromRectAndCorners(
      progressRect,
      topLeft: Radius.circular(cornerRadius - borderWidth - innerPadding),
      bottomLeft: Radius.circular(cornerRadius - borderWidth - innerPadding),
      topRight:
          (currentWidth >=
              innerRect.width - (cornerRadius - borderWidth - innerPadding))
          ? Radius.circular(cornerRadius - borderWidth - innerPadding)
          : Radius.zero,
      bottomRight:
          (currentWidth >=
              innerRect.width - (cornerRadius - borderWidth - innerPadding))
          ? Radius.circular(cornerRadius - borderWidth - innerPadding)
          : Radius.zero,
    );

    final Paint progressPaint = Paint()..color = progressColor; // Ana sarı
    canvas.drawRRect(progressRRect, progressPaint);

    // Çizgili deseni çizelim
    const double stripeWidth = 5.0; // Çizgi kalınlığı
    const double stripeSpacing = 5.0; // Çizgiler arası boşluk
    final double angle = -math.pi / 4; // -45 derece eğim (yönü ters çevirir)

    canvas.save();
    canvas.clipRRect(progressRRect); // İlerleme alanının dışına taşmasın

    // Çizgi rengini, ana sarıdan biraz daha koyu veya daha az doygun bir sarı tonu olarak belirleyelim.
    // Örnek olarak, Colors.amber'ın biraz daha koyu bir tonunu veya Colors.orange[200] gibi bir şeyi deneyebiliriz.
    // Veya Colors.yellow.withOpacity(0.7) gibi daha sarı ama farklı bir opaklık.
    final Paint stripePaint = Paint()
      ..color = progressColor
          .withOpacity(0.7)
          .withRed(
            (progressColor.red * 0.9).toInt(),
          ) // Sarıdan biraz daha koyu ve daha az şeffaf
      // Diğer bir deneme: progressColor'ın HSL değerlerini değiştirerek daha az doygun yapmak
      // HSLColor.fromColor(progressColor).withLightness(HSLColor.fromColor(progressColor).lightness * 0.8).toColor()
      ..strokeWidth = stripeWidth;

    // Ya da doğrudan bir renk kodu deneyelim:
    // final Paint stripePaint = Paint()..color = const Color(0xFFD4AF37).withOpacity(0.7); // Altın sarısı gibi bir ton

    // Ya da Colors.yellowAccent.withOpacity(0.5) gibi sarı tonu ama şeffaf.
    // Resimdeki "gölge" etkisini vermek için Colors.black.withOpacity(0.1) gibi siyah çizgiler de denenebilir.
    // Şu anki görseldeki gibi "sarının üzerinde daha koyu sarı" etkisi için:
    final Color darkerAmber = Color.alphaBlend(
      Colors.black.withOpacity(0.15),
      progressColor,
    ); // Sarı üzerine hafif siyah bindirme
    final Paint finalStripePaint = Paint()
      ..color =
          darkerAmber // Bu renk, ana sarının üzerine hafif siyah ekleyerek oluştu
      ..strokeWidth = stripeWidth;

    // Çizgileri çiz
    for (
      double i = -size.height;
      i < size.width + size.height;
      i += stripeWidth + stripeSpacing
    ) {
      canvas.drawLine(
        Offset(i + progressRect.left, progressRect.top),
        Offset(
          i + progressRect.left + progressRect.height / math.tan(-angle),
          progressRect.bottom,
        ),
        finalStripePaint, // Final stripe paint kullanıldı
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StrippedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.innerPadding != innerPadding;
  }
}

// MilestoneProgressBar ve main fonksiyonları aynı kalabilir.
// (Önceki mesajdaki kodlar burada tekrar verilmedi, ancak aynı şekilde kullanılabilir.)

// MilestoneProgressBar ve main fonksiyonları aynı kalabilir.
// (Önceki mesajdaki kodlar burada tekrar verilmedi, ancak aynı şekilde kullanılabilir.)

// MilestoneProgressBar ve main fonksiyonları aynı kalabilir, sadece StrippedProgressPainter'ı kullanacaklar.
// Eğer MilestoneProgressBar veya main fonksiyonunda da değişiklik yapmamı isterseniz lütfen belirtin.

// Önceki MilestoneProgressBar ve main fonksiyonları aşağıdadır, değişiklik yapmadım:
class MilestoneProgressBar extends StatelessWidget {
  final int currentPoints;
  final List<int> milestones; // Örneğin: [40, 80, 120, 160]
  final double height; // Çubuğun yüksekliği
  final double milestoneCircleRadius; // Milestone dairelerinin yarıçapı

  const MilestoneProgressBar({
    super.key,
    required this.currentPoints,
    required this.milestones,
    this.height = 30.0, // Resimdeki çubuk daha yüksek görünüyor
    this.milestoneCircleRadius = 15.0, // Resimdeki boyutlara göre ayarlandı
  });

  @override
  Widget build(BuildContext context) {
    // Toplam maksimum puan (son milestone'a kadar)
    final int maxMilestone = milestones.last;
    // İlerleme oranı (0.0 ile 1.0 arasında)
    final double progress = (currentPoints / maxMilestone).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double progressBarWidth = constraints.maxWidth;

        return SizedBox(
          // Kapsayıcıya dış kenarlık ekleyebiliriz veya painter içinde bırakabiliriz.
          // Bu tasarımda painter içinde olması daha iyi.
          height:
              height, // Çubuk yüksekliği + milestone'ların çubuktan çıkan kısmı için biraz daha fazla.
          child: Stack(
            alignment: Alignment.centerLeft, // Stack içeriğini sola hizala
            children: [
              // CustomPaint ile ilerleme çubuğunu çiz
              CustomPaint(
                size: Size(progressBarWidth, height), // Painter'ın çizim alanı
                painter: StrippedProgressPainter(
                  progress: progress,
                  cornerRadius:
                      height /
                      2, // Çubuğun yüksekliğinin yarısı kadar köşe (tam oval için)
                  // Diğer renkler ve kalınlıklar StrippedProgressPainter'da tanımlı
                ),
              ),

              // Milestone noktaları
              ...milestones.map((milestone) {
                // Milestone'ın çubuk üzerindeki konumunu hesapla
                // Her milestone, toplam çubuk genişliğinin kendi milestone değerinin maxMilestone'a oranına göre konumlanır.
                // Yarıçapı ve kenarlık payı ekleyerek merkezleme yapılır.
                final double positionFactor = milestone / maxMilestone;
                final double leftPosition =
                    progressBarWidth * positionFactor - milestoneCircleRadius;

                return Positioned(
                  left: leftPosition,
                  // Merkezleme için (height / 2) - milestoneCircleRadius
                  // Dairenin çubuktan biraz dışarı çıkmasını istiyorsak, ona göre ayarlanır.
                  top: (height / 2) - milestoneCircleRadius,
                  child: _buildMilestoneCircle(
                    milestone,
                    currentPoints >= milestone,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Milestone çemberi widget'ı
  Widget _buildMilestoneCircle(int milestone, bool isReached) {
    return Container(
      width: milestoneCircleRadius * 2,
      height: milestoneCircleRadius * 2,
      decoration: BoxDecoration(
        color: Colors.amber, // Her zaman sarı
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          milestone.toString(),
          style: const TextStyle(
            color: Colors.white, // Beyaz rakamlar
            fontWeight: FontWeight.bold,
            fontSize: 18, // Boyutu ayarla
            shadows: [
              Shadow(
                // Metne siyah dış çizgi (stroke) efekti vermek için
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
              Shadow(
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(-1.0, -1.0),
              ),
              Shadow(
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(1.0, -1.0),
              ),
              Shadow(
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(-1.0, 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
