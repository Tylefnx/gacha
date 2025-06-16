import 'package:flutter/material.dart';
import 'package:gacha/item.dart';

class SpinWheelProvider extends ChangeNotifier {
  int selectedIndex = -1;
  int remainingSpins = 399;

  final List<GameItem> items = List.generate(
    12,
    (i) => GameItem(
      quantity: 10 * (i + 1),
      name: 'Ödül ${i + 1}',
      bgColor: Colors.primaries[i % Colors.primaries.length].value,
      imageFile: null,
    ),
  );

  Future<void> spinOnce() async {
    if (remainingSpins <= 0) return;
    remainingSpins--;
    notifyListeners();

    for (int i = 0; i < 12; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      selectedIndex = i;
      notifyListeners();
    }
  }
}
