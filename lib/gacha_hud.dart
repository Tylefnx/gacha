import 'package:flutter/material.dart';
import 'package:gacha/currency_bar_hud.dart';

class GachaHud extends StatelessWidget {
  const GachaHud({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _GachaTitleSection(),
        CurrencyBarHud(
          currencyImagePath: 'assets/gacha_icon.png',
          amount: 1000,
        ),
      ],
    );
  }
}

class _GachaTitleSection extends StatelessWidget {
  const _GachaTitleSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: Icon(Icons.question_mark, color: Colors.black),
        ),
        SizedBox(width: 10),
        Text(
          'Şanslı Çekiliş',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
