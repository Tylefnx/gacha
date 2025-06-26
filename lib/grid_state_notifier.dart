import 'dart:math';

import 'package:flutter/material.dart';

class GridStateNotifier extends ChangeNotifier {
  int? _animatedBoxIndex; // Kalıcı olarak animasyon yapılacak kutunun indexi
  int? get animatedBoxIndex => _animatedBoxIndex;

  int?
  _highlightedBoxIndex; // Turlama sırasında anlık vurgulanan kutunun indexi
  int? get highlightedBoxIndex => _highlightedBoxIndex;

  // Kullanılabilir indeksler (merkezdekiler hariç)
  final List<int> _availableIndices = [];
  List<int> get availableIndices => _availableIndices;
  GridStateNotifier() {
    _initAvailableIndices();
  }

  void _initAvailableIndices() {
    for (int i = 0; i < 16; i++) {
      print(i);
      if (![5, 6, 9, 10].contains(i)) {
        _availableIndices.add(i);
      }
    }
  }

  Future<void> startSpinningAndSelect() async {
    // Önceki animasyonu sıfırla
    _animatedBoxIndex = null;
    notifyListeners();

    final List<int> pattern = [0, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4];
    final Random random = Random();
    final int repeatCount =
        3; // Kaç kez pattern dönsün istiyorsan burayı değiştir
    final List<int> sequence = List.generate(
      repeatCount * pattern.length,
      (index) => pattern[index % pattern.length],
    );

    for (int index in sequence) {
      print(index);
      _highlightedBoxIndex = index;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 70));
    }

    _animatedBoxIndex = pattern[random.nextInt(pattern.length)];
    _highlightedBoxIndex = null;
    notifyListeners();
  }

  Future<void> spinMultipleTimes(int times) async {
    for (int i = 0; i < times; i++) {
      await startSpinningAndSelect();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void resetAnimation() {
    _animatedBoxIndex = null;
    _highlightedBoxIndex = null;
    notifyListeners();
  }
}
