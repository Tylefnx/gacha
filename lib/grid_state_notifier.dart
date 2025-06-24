import 'dart:math';

import 'package:flutter/material.dart';

class GridStateNotifier extends ChangeNotifier {
  int? _animatedBoxIndex; // Kalıcı olarak animasyon yapılacak kutunun indeksi
  int? get animatedBoxIndex => _animatedBoxIndex;

  int?
  _highlightedBoxIndex; // Turlama sırasında anlık vurgulanan kutunun indeksi
  int? get highlightedBoxIndex => _highlightedBoxIndex;

  final List<String> _boxImageUrls = List.generate(16, (index) {
    if ([5, 6, 9, 10].contains(index)) {
      return '';
    }
    return 'https://picsum.photos/id/${index + 10}/100/100'; // Örnek resimler
  });

  String getBoxImageUrl(int index) => _boxImageUrls[index];

  // Kullanılabilir indeksler (merkezdekiler hariç)
  List<int> _availableIndices = [];

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

  // Turlama ve ardından nihai seçimi yapacak yeni metot
  Future<void> startSpinningAndSelect() async {
    // Önceki animasyonu sıfırla
    _animatedBoxIndex = null;
    notifyListeners();

    final Random random = Random();
    int spinCount =
        _availableIndices.length * 2 +
        random.nextInt(
          _availableIndices.length,
        ); // En az 2 tur dön + rastgele ek tur

    for (int i = 0; i < spinCount; i++) {
      _highlightedBoxIndex = _availableIndices[i % _availableIndices.length];
      notifyListeners();
      await Future.delayed(
        const Duration(milliseconds: 70),
      ); // Vurgulama hızı (ayarlanabilir)
    }

    // Turlama bittiğinde, nihai seçimi yap
    _animatedBoxIndex =
        _availableIndices[random.nextInt(_availableIndices.length)];
    _highlightedBoxIndex = null; // Turlama vurgusunu kaldır
    notifyListeners(); // Nihai seçimi ve turlamanın bittiğini bildir
  }

  // Animasyonu sıfırlamak için
  void resetAnimation() {
    _animatedBoxIndex = null;
    _highlightedBoxIndex = null;
    notifyListeners();
  }
}
