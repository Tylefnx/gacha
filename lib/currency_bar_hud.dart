import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart'; // Eğer withValues yerine withOpacity kullanılıyorsa bu import kaldırılabilir.
import 'package:gacha/app_colors.dart';

class CurrencyBarHud extends StatelessWidget {
  final String currencyImagePath;
  final int amount;

  const CurrencyBarHud({
    super.key,
    required this.currencyImagePath,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    const double containerHeight = 38;
    const double barHeight = 28;
    const double barTopOffset = (containerHeight - barHeight) / 2;

    return SizedBox(
      width: 107,
      height: containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // _CurrencyBarContainer içeriği
          Positioned(
            right: 0,
            top: barTopOffset,
            child: Container(
              width: 102,
              height: barHeight,
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
          ),
          // _CurrencyBarText içeriği
          Positioned(
            right: 0,
            top: barTopOffset,
            child: Container(
              width: 102,
              height: barHeight,
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
          ),
          // _CurrencyBarImage içeriği
          Positioned(
            left: -5,
            top: (containerHeight - 35) / 2,
            child: Image.asset(
              currencyImagePath,
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ),
          ),
          // _BuyCurrencyButton içeriği
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
      left: 20,
      bottom: 0,
      child: InkWell(
        onTap: () {
          // TODO: Tıklama işlevi eklenecek
        },
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.darkGreen),
            gradient: const LinearGradient(
              colors: [AppColors.green, AppColors.whitishGreen],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 14),
        ),
      ),
    );
  }
}
