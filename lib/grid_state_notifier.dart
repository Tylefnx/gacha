import 'dart:math';
import 'package:flutter/material.dart';

class GridStateNotifier extends ChangeNotifier {
  int? _animatedBoxIndex;
  int? get animatedBoxIndex => _animatedBoxIndex;

  int? _highlightedBoxIndex;
  int? get highlightedBoxIndex => _highlightedBoxIndex;

  int? _lastSelectedIndex;

  final List<int> _availableIndices = [];
  List<int> get availableIndices => _availableIndices;

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

    final List<int> pattern = [0, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4];
    final Random random = Random();
    final int repeatCount = 3;

    final int startIndexInPattern =
        _lastSelectedIndex != null && pattern.contains(_lastSelectedIndex)
        ? pattern.indexOf(_lastSelectedIndex!)
        : 0;

    final List<int> fastSpinSequence = [];
    for (int i = 0; i < repeatCount; i++) {
      for (int j = 0; j < pattern.length; j++) {
        fastSpinSequence.add(
          pattern[(startIndexInPattern + j) % pattern.length],
        );
      }
    }

    for (int index in fastSpinSequence) {
      _highlightedBoxIndex = index;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 70));
    }

    // Rastgele son kutuyu seç
    final int finalSelectedIndex = pattern[random.nextInt(pattern.length)];
    final int currentHighlightIndexInPattern =
        _highlightedBoxIndex != null && pattern.contains(_highlightedBoxIndex!)
        ? pattern.indexOf(_highlightedBoxIndex!)
        : startIndexInPattern;

    final List<int> slowTransitionSequence = [];
    int currentIndex = currentHighlightIndexInPattern;

    while (true) {
      slowTransitionSequence.add(pattern[currentIndex]);
      if (pattern[currentIndex] == finalSelectedIndex) {
        break; // Hedefe ulaştık, döngüyü kır
      }
      currentIndex = (currentIndex + 1) % pattern.length;
    }

    for (int index in slowTransitionSequence) {
      _highlightedBoxIndex = index;
      notifyListeners();
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Daha yavaş bir gecikme
    }

    _animatedBoxIndex = finalSelectedIndex;
    _highlightedBoxIndex = null;
    notifyListeners();

    _lastSelectedIndex = finalSelectedIndex;
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
    _lastSelectedIndex = null;
    notifyListeners();
  }
}

int findShortestCircularDistance(List<int> list, int value1, int value2) {
  final int index1 = list.indexOf(value1);
  final int index2 = list.indexOf(value2);

  final int listLength = list.length;

  int forwardDistance = (index2 - index1 + listLength) % listLength;

  int backwardDistance = (index1 - index2 + listLength) % listLength;

  return min(forwardDistance, backwardDistance);
}
