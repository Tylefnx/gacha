import 'package:flutter/material.dart';
import 'package:gacha/gacha_page.dart';

class GachaHud extends StatelessWidget {
  const GachaHud({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(Icons.question_mark, color: Colors.black),
            ),
            Text(
              'Şanslı Çekiliş',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        TCoinDisplay(),
      ],
    );
  }
}
