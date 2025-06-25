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

  GridStateNotifier() {
    _initAvailableIndices();
  }

  void _initAvailableIndices() {
    for (int i = 0; i < 16; i++) {
      if (![5, 6, 9, 10].contains(i)) {
        _availableIndices.add(i);
      }
    }
  }

  Future<void> startSpinningAndSelect() async {
    // Önceki animasyonu sıfırla
    _animatedBoxIndex = null;
    notifyListeners();

    final Random random = Random();
    int spinCount =
        _availableIndices.length * 2 + random.nextInt(_availableIndices.length);
    for (int i = 0; i < spinCount; i++) {
      _highlightedBoxIndex = _availableIndices[i % _availableIndices.length];
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 70));
    }

    _animatedBoxIndex =
        _availableIndices[random.nextInt(_availableIndices.length)];
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
