import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gacha_hud.dart';
import 'package:gacha/game_item.dart';
import 'package:gacha/gift_box_row.dart';
import 'package:gacha/grid_state_notifier.dart'; // Make sure this import is correct
import 'package:gacha/reward_progress_bar.dart';
import 'package:provider/provider.dart';

class GachaPage extends StatelessWidget {
  const GachaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Şanslı Çekiliş'),
        backgroundColor: const Color(0xFF330066),
        foregroundColor: Colors.white,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [AppColors.darkPurple, AppColors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<GridStateNotifier>(
            builder: (context, gridStateNotifier, child) {
              return _GachaPageContents(
                milestones: gridStateNotifier.milestones,
                currentPoints: gridStateNotifier.currentPoints,
                maxPoints: gridStateNotifier.maxPoints,
                collectedChests: gridStateNotifier.collectedChests,
                items: gridStateNotifier.items,
              );
            },
          ),
        ),
      ),
      floatingActionButton: const _GachaPageButtons(),
    );
  }
}

class _GachaPageButtons extends StatelessWidget {
  const _GachaPageButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      // 'spacing' is not a direct property of Row.
      // You can use SizedBox for spacing between children.
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: spin(context),
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.shuffle),
        ),
        const SizedBox(width: 50), // Added spacing
        FloatingActionButton(
          onPressed: spinTenTimes(context),
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.access_time),
        ),
      ],
    );
  }
}

class _GachaPageContents extends StatelessWidget {
  const _GachaPageContents({
    required this.milestones,
    required this.currentPoints,
    required this.maxPoints,
    required this.collectedChests,
    required this.items,
  });

  final List<int> milestones;
  final int currentPoints;
  final int maxPoints;
  final int collectedChests;
  final List<GameItem> items; // GameItem definition is now in GridStateNotifier

  @override
  Widget build(BuildContext context) {
    return Column(
      // 'spacing' is not a direct property of Column.
      // You can use SizedBox for spacing between children.
      children: [
        const GachaHud(),
        const SizedBox(height: 15), // Added spacing
        GiftBoxRow(
          milestones: milestones,
          currentPoints: currentPoints,
          maxPoints: maxPoints,
          collectedChests: collectedChests,
        ),
        const SizedBox(height: 15), // Added spacing
        RewardProgressBarWithMilestones(
          currentPoints: currentPoints,
          milestones: milestones,
        ),
        const SizedBox(height: 15), // Added spacing
        Expanded(
          // Use Expanded to ensure the grid takes available space
          child: AnimatedGridBoxWithProvider(gameItems: items),
        ),
      ],
    );
  }
}

void Function() spinTenTimes(BuildContext context) {
  return () {
    Provider.of<GridStateNotifier>(
      context,
      listen: false,
    ).spinMultipleTimes(10);
  };
}

void Function() spin(BuildContext context) {
  return () {
    Provider.of<GridStateNotifier>(
      context,
      listen: false,
    ).startSpinningAndSelect();
  };
}
