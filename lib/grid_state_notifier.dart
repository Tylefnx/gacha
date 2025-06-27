import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gacha/game_item.dart';
import 'package:gacha/get_mock_game_items.dart';

class GridStateNotifier extends ChangeNotifier {
  // Animation and Highlight state
  int? _animatedBoxIndex;
  int? get animatedBoxIndex => _animatedBoxIndex;

  int? _highlightedBoxIndex;
  int? get highlightedBoxIndex => _highlightedBoxIndex;

  int? _lastSelectedIndex;

  final List<int> _availableIndices = [];
  List<int> get availableIndices => _availableIndices;

  // Game data properties
  int _currentPoints;
  int get currentPoints => _currentPoints;

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
      _items =
          getMockGameItems(), // Assuming getMockGameItems() is defined elsewhere
      _milestones = [40, 80, 120, 160],
      _maxPoints = 75,
      _collectedChests = 44 {
    _initAvailableIndices();
  }

  void _initAvailableIndices() {
    for (int i = 0; i < 16; i++) {
      if (![5, 6, 9, 10].contains(i)) {
        _availableIndices.add(i);
      }
    }
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
    // Reset previous animation
    _animatedBoxIndex = null;
    notifyListeners();

    final List<int> pattern = [0, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4];
    final Random random = Random();
    const int repeatCount = 3;

    final int startIndexInPattern =
        _lastSelectedIndex != null && pattern.contains(_lastSelectedIndex)
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

    final int currentHighlightIndexInPattern =
        _highlightedBoxIndex != null && pattern.contains(_highlightedBoxIndex)
        ? pattern.indexOf(_highlightedBoxIndex!)
        : startIndexInPattern;

    final List<int> slowTransitionSequence = [];
    int currentIndex = currentHighlightIndexInPattern;
    do {
      slowTransitionSequence.add(pattern[currentIndex]);
      if (pattern[currentIndex] == finalSelectedIndex) {
        break;
      }
      currentIndex = (currentIndex + 1) % pattern.length;
    } while (true);

    await _spinSequence(
      sequence: slowTransitionSequence,
      delay: const Duration(milliseconds: 300),
    );

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

  void addPoints(int amount) {
    _currentPoints += amount;
    notifyListeners();
  }

  void addCollectedChest() {
    _collectedChests++;
    notifyListeners();
  }
}

int findShortestCircularDistance(List<int> list, int value1, int value2) {
  final index1 = list.indexOf(value1);
  final index2 = list.indexOf(value2);
  final listLength = list.length;
  final forwardDistance = (index2 - index1 + listLength) % listLength;
  final backwardDistance = (index1 - index2 + listLength) % listLength;

  return min(forwardDistance, backwardDistance);
}
