import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gacha_hud.dart';
import 'package:gacha/gift_box_row.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:gacha/reward_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:gacha/game_item.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class GachaPage extends StatelessWidget {
  const GachaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPoints = 80;
    final List<GameItem> mockItems = getMockGameItems();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Şanslı Çekiliş'),
        backgroundColor: const Color(0xFF330066),
        foregroundColor: Colors.white,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
          gradient: const LinearGradient(
            colors: [AppColors.darkPurple, AppColors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 15,
            children: [
              GachaHud(),
              GiftBoxRow(
                milestones: [40, 80, 120, 160],
                currentPoints: currentPoints,
                maxPoints: 75,
                collectedChests: 44,
              ),
              RewardProgressBarWithMilestones(
                currentPoints: currentPoints,
                milestones: [40, 80, 120, 160],
              ),
              AnimatedGridBoxWithProvider(gameItems: mockItems),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        spacing: 50,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: spin(context),
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            child: const Icon(Icons.shuffle),
          ),
          FloatingActionButton(
            onPressed: spinTenTimes(context),
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            child: const Icon(Icons.access_time),
          ),
        ],
      ),
    );
  }
}

void Function() spinTenTimes(BuildContext context) {
  return () {
    Provider.of<GridStateNotifier>(
      context,
      listen: false,
    ).spinMultipleTimes(10);
  };
}

void Function() spin(BuildContext context) {
  return () {
    Provider.of<GridStateNotifier>(
      context,
      listen: false,
    ).startSpinningAndSelect();
  };
}

class TCoinDisplay extends StatelessWidget {
  const TCoinDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 107, // Tasarımın toplam genişliği
      height:
          38, // Tasarımın toplam yüksekliği (Coin'in üstten taşması için biraz artırıldı)
      child: Stack(
        // Çocuk widget'larının ebeveyn sınırları dışına taşmasına izin verir
        clipBehavior: Clip.none,
        children: [
          // 1. Sağdaki "1000" yazan dikdörtgenin dış çerçevesi (border)
          // Dikdörtgenin dikeyde ortalanması için top değeri ayarlandı
          Positioned(
            right: 0,
            top:
                (38 - 28) /
                2, // Kapsayıcı (38) ve dikdörtgen (28) yüksekliğine göre dikeyde ortala
            child: Container(
              width: 102,
              height: 28,
              decoration: BoxDecoration(
                // Figma'daki inset shadow etkisi için doğrudan bir karşılık yok.
                // Bu gölge dışarıya doğru olacaktır.
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF241F0F,
                    ).withOpacity(0.4), // Gölge rengi ve opaklık
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: const Offset(0, 4), // Dışarı doğru bir gölge
                  ),
                ],
                borderRadius: BorderRadius.circular(35), // Yuvarlak köşeler
                border: Border.all(
                  color: const Color(
                    0xFFFFB302,
                  ), // Sarı kenarlık rengi (tam opak)
                  width: 2, // Kenarlık kalınlığı
                ),
              ),
              // Çerçevenin içindeki gradyanlı alanı, opaklık ile birlikte
              child: Opacity(
                opacity: 0.2, // %20 opaklık
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white, // Beyaz renk
                        Color(0xFFB68A0B), // B68A0B hex kodu
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      35,
                    ), // İç dolgu da yuvarlak olmalı
                  ),
                ),
              ),
            ),
          ),
          // 1.5. Dikdörtgenin üzerindeki "1000" yazısı (opaklık olmadan görünmesi için ayrı bir Positioned)
          Positioned(
            right: 0,
            top: (38 - 28) / 2, // Dikdörtgenle aynı dikey konuma getir
            child: Container(
              width: 102,
              height: 28,
              alignment: Alignment.centerRight, // Yazıyı sağa yaslar
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0), // Sağdan boşluk
                child: Text(
                  '1000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Mevcut font boyutu korundu
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // 2. Coin (madeni para) görseli
          Positioned(
            left:
                -5, // Coin'in sol kenardan biraz dışarı taşmasını sağlar (Figma'daki gibi)
            top:
                (38 - 35) /
                2, // Kapsayıcı (38) ve coin (35) yüksekliğine göre dikeyde ortala
            child: Image.asset(
              'assets/tcoin.png', // Resminizin doğru yolu
              width: 35, // Coin'in genişliği
              height: 35, // Coin'in yüksekliği
              fit: BoxFit.contain, // İçine sığdırma modu
            ),
          ),
          // 3. Ortadaki yeşil artı butonu (Şimdi gradyanlı!)
          Positioned(
            // Butonun coin ile dikdörtgen arasına gelmesi için konumlandırıldı
            left: 20,
            bottom: 0,
            child: InkWell(
              onTap: () {
                // Tıklama işlevi eklenebilir
              },
              child: Container(
                width: 16, // Butonun genişliği
                height: 16, // Butonun yüksekliği
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkGreen),
                  // BURAYA YEŞİL VE BEYAZ GRADYAN EKLENDİ
                  gradient: LinearGradient(
                    colors: [AppColors.green, AppColors.whitishGreen],
                    begin: Alignment.bottomCenter, // Gradyan başlangıç yönü
                    end: Alignment.topCenter, // Gradyan bitiş yönü
                  ),
                  // 'color: Colors.green' satırı kaldırıldı çünkü gradyan tanımlandı
                  shape: BoxShape.circle, // Yuvarlak şekil
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 14, // Artı ikonunun boyutu
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
