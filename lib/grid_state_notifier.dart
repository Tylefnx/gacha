import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gacha/game_item.dart';
import 'package:gacha/get_mock_game_items.dart';

class GridStateNotifier extends ChangeNotifier {
  int? _animatedBoxIndex;
  int? get animatedBoxIndex => _animatedBoxIndex;

  int? _highlightedBoxIndex;
  int? get highlightedBoxIndex => _highlightedBoxIndex;

  int? _lastSelectedIndex;

  final List<int> _availableIndices = [];
  List<int> get availableIndices => _availableIndices;

  int _currentPoints;
  int get currentPoints => _currentPoints;
  bool spinningCooldown = false;
  final List<GameItem> _items;
  List<GameItem> get items => _items;

  final List<int> _milestones;
  List<int> get milestones => _milestones;

  final int _maxPoints;
  int get maxPoints => _maxPoints;

  int _collectedChests;
  int get collectedChests => _collectedChests;

  GridStateNotifier()
    : _currentPoints = 80,
      _items = getMockGameItems(),
      _milestones = [40, 80, 120, 160],
      _maxPoints = 75,
      _collectedChests = 44 {
    _initAvailableIndices();
  }

  void _initAvailableIndices() {
    _availableIndices.addAll(
      List.generate(16, (i) => i).where((i) => ![5, 6, 9, 10].contains(i)),
    );
  }

  Future<void> _spinSequence({
    required List<int> sequence,
    required Duration delay,
  }) async {
    for (final int index in sequence) {
      _highlightedBoxIndex = index;
      notifyListeners();
      await Future.delayed(delay);
    }
  }

  Future<void> startSpinningAndSelect() async {
    if (spinningCooldown) return;
    spinningCooldown = true;
    _animatedBoxIndex = null;
    notifyListeners();

    final List<int> pattern = [0, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4];
    final Random random = Random();
    const int repeatCount = 3;

    final int startIndexInPattern =
        (_lastSelectedIndex != null && pattern.contains(_lastSelectedIndex))
        ? pattern.indexOf(_lastSelectedIndex!)
        : 0;

    final List<int> fastSpinSequence = List.generate(
      repeatCount * pattern.length,
      (i) => pattern[(startIndexInPattern + i) % pattern.length],
    );

    await _spinSequence(
      sequence: fastSpinSequence,
      delay: const Duration(milliseconds: 70),
    );

    final int finalSelectedIndex = pattern[random.nextInt(pattern.length)];

    final List<int> slowTransitionSequence = [];
    int currentIndex =
        _highlightedBoxIndex != null && pattern.contains(_highlightedBoxIndex)
        ? pattern.indexOf(_highlightedBoxIndex!)
        : startIndexInPattern;

    // Hedef indekse kadar döngü
    while (true) {
      slowTransitionSequence.add(pattern[currentIndex]);
      if (pattern[currentIndex] == finalSelectedIndex) {
        break;
      }
      currentIndex = (currentIndex + 1) % pattern.length;
    }

    await _spinSequence(
      sequence: slowTransitionSequence,
      delay: const Duration(milliseconds: 300),
    );

    _animatedBoxIndex = finalSelectedIndex;
    _highlightedBoxIndex = null;
    notifyListeners();

    _lastSelectedIndex = finalSelectedIndex;
    spinningCooldown = false;
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

  void addPoints(int amount) {
    _currentPoints += amount;
    notifyListeners();
  }

  void addCollectedChest() {
    _collectedChests++;
    notifyListeners();
  }
}
