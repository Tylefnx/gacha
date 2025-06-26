import 'dart:math';

import 'package:flutter/material.dart';

class GridStateNotifier extends ChangeNotifier {
  int? _animatedBoxIndex; // Kalıcı olarak animasyon yapılacak kutunun indexi
  int? get animatedBoxIndex => _animatedBoxIndex;

  int?
  _highlightedBoxIndex; // Turlama sırasında anlık vurgulanan kutunun indexi
  int? get highlightedBoxIndex => _highlightedBoxIndex;

  int? _lastSelectedIndex; // Son seçilen index'i saklamak için ekledik

  // Kullanılabilir indeksler (merkezdekiler hariç)
  final List<int> _availableIndices = [];
  List<int> get availableIndices => _availableIndices;

  GridStateNotifier() {
    _initAvailableIndices();
  }

  void _initAvailableIndices() {
    for (int i = 0; i < 16; i++) {
      // print(i); // Bu satırı üretim kodunuzda kaldırabilirsiniz
      if (![5, 6, 9, 10].contains(i)) {
        _availableIndices.add(i);
      }
    }
    // İlk çalıştırmada _lastSelectedIndex'i mevcut pattern'daki ilk elemana ayarlayabiliriz
    // Ya da null kalıp, ilk dönüşte pattern'ın başından başlamasını sağlayabiliriz.
    // Şimdilik null bırakıp ilk dönüşte pattern[0]'dan başlamasını sağlayalım.
  }

  Future<void> startSpinningAndSelect() async {
    // Önceki animasyonu sıfırla
    _animatedBoxIndex = null;
    notifyListeners();

    // Pattern'ınızdaki sıraya dikkat edin, bu 4x4 bir grid için
    // dış kenarları dolaşıyor gibi görünüyor.
    final List<int> pattern = [0, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4];
    final Random random = Random();
    final int repeatCount =
        3; // Kaç kez pattern dönsün istiyorsan burayı değiştir

    // Son seçilen index'i başlangıç noktası olarak al
    // Eğer hiç seçilmediyse veya pattern içinde değilse, pattern'ın ilk elemanını kullan
    final int startIndexInPattern =
        _lastSelectedIndex != null && pattern.contains(_lastSelectedIndex)
        ? pattern.indexOf(_lastSelectedIndex!)
        : 0;

    // Yeni sequence'i oluştur, son seçilen indexten başlayarak
    final List<int> sequence = [];
    for (int i = 0; i < repeatCount; i++) {
      for (int j = 0; j < pattern.length; j++) {
        // Modulo operatörü ile pattern'ın etrafında dönmeyi sağlıyoruz
        sequence.add(pattern[(startIndexInPattern + j) % pattern.length]);
      }
    }

    // Animasyon döngüsü
    for (int index in sequence) {
      _highlightedBoxIndex = index;
      notifyListeners();
      await Future.delayed(
        const Duration(milliseconds: 70),
      ); // Kutular arası geçiş hızı
    }

    // Rastgele bir index seç ve kalıcı olarak ayarla
    final int newSelectedIndex = pattern[random.nextInt(pattern.length)];
    _animatedBoxIndex = newSelectedIndex;
    _highlightedBoxIndex = null; // Turlama highlight'ını temizle
    notifyListeners();

    // Son seçilen index'i bir sonraki dönüş için güncelle
    _lastSelectedIndex = newSelectedIndex;
  }

  Future<void> spinMultipleTimes(int times) async {
    for (int i = 0; i < times; i++) {
      await startSpinningAndSelect();
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Her spin sonrası bekleme
    }
  }

  void resetAnimation() {
    _animatedBoxIndex = null;
    _highlightedBoxIndex = null;
    _lastSelectedIndex = null; // Resetlerken son seçileni de sıfırlayalım
    notifyListeners();
  }
}
