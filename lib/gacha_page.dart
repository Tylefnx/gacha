import 'package:flutter/material.dart' hide BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gacha_hud.dart';
import 'package:gacha/game_item.dart';
import 'package:gacha/gift_box_row.dart';
import 'package:gacha/grid_state_notifier.dart';
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
      floatingActionButton:
          const _GachaPageButtons(), // Changed to instantiate without const
    );
  }
}

class _GachaPageContents extends StatelessWidget {
  final List<int> milestones;
  final int currentPoints;
  final int maxPoints;
  final int collectedChests;
  final List<GameItem> items;

  const _GachaPageContents({
    required this.milestones,
    required this.currentPoints,
    required this.maxPoints,
    required this.collectedChests,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const GachaHud(),
        const SizedBox(height: 10),
        GiftBoxRow(
          milestones: milestones,
          currentPoints: currentPoints,
          maxPoints: maxPoints,
          collectedChests: collectedChests,
        ),
        RewardProgressBarWithMilestones(
          currentPoints: currentPoints,
          milestones: milestones,
        ),
        Expanded(child: AnimatedGridBoxWithProvider(gameItems: items)),
      ],
    );
  }
}

class _GachaPageButtons extends StatelessWidget {
  const _GachaPageButtons();

  GridStateNotifier _notifier(BuildContext context) =>
      Provider.of<GridStateNotifier>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () =>
              _notifier(context).startSpinningAndSelect(), // Direct call
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.shuffle),
        ),
        const SizedBox(width: 50),
        FloatingActionButton(
          onPressed: () =>
              _notifier(context).spinMultipleTimes(10), // Direct call
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.access_time),
        ),
      ],
    );
  }
}
