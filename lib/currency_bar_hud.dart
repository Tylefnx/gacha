import 'package:flutter/material.dart';
import 'package:gacha/app_colors.dart';

class CurrencyBarHud extends StatelessWidget {
  const CurrencyBarHud({
    super.key,
    required this.currencyImagePath,
    required this.amount,
  });
  final String currencyImagePath;
  final int amount;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 107, // Tasarımın toplam genişliği
      height: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const _CurrencyBarContainer(),
          _CurrencyBarText(amount: amount),
          _CurrencyBarImage(currencyImagePath: currencyImagePath),
          const _BuyCurrencyButton(),
        ],
      ),
    );
  }
}

class _BuyCurrencyButton extends StatelessWidget {
  const _BuyCurrencyButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
            gradient: const LinearGradient(
              colors: [AppColors.green, AppColors.whitishGreen],
              begin: Alignment.bottomCenter, // Gradyan başlangıç yönü
              end: Alignment.topCenter, // Gradyan bitiş yönü
            ),
            // 'color: Colors.green' satırı kaldırıldı çünkü gradyan tanımlandı
            shape: BoxShape.circle, // Yuvarlak şekil
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
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
    );
  }
}

class _CurrencyBarImage extends StatelessWidget {
  const _CurrencyBarImage({required this.currencyImagePath});

  final String currencyImagePath;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left:
          -5, // Coin'in sol kenardan biraz dışarı taşmasını sağlar (Figma'daki gibi)
      top:
          (38 - 35) /
          2, // Kapsayıcı (38) ve coin (35) yüksekliğine göre dikeyde ortala
      child: Image.asset(
        currencyImagePath, // Resminizin doğru yolu
        width: 35, // Coin'in genişliği
        height: 35, // Coin'in yüksekliği
        fit: BoxFit.contain, // İçine sığdırma modu
      ),
    );
  }
}

class _CurrencyBarText extends StatelessWidget {
  const _CurrencyBarText({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: (38 - 28) / 2,
      child: Container(
        width: 102,
        height: 28,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            '$amount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrencyBarContainer extends StatelessWidget {
  const _CurrencyBarContainer();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: (38 - 28) / 2,
      child: Container(
        width: 102,
        height: 28,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF241F0F).withValues(alpha: 0.4),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: AppColors.mustard, width: 2),
        ),
        child: Opacity(
          opacity: 0.2,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, AppColors.darkMustard],
              ),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ),
      ),
    );
  }
}
