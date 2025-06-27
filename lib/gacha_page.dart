import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gacha_hud.dart';
import 'package:gacha/gift_box_row.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:gacha/reward_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:gacha/game_item.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class GachaPage extends StatelessWidget {
  const GachaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPoints = 80;
    final items = getMockGameItems();
    final milestones = [40, 80, 120, 160];
    final maxPoints = 75;
    final collectedChests = 44;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Şanslı Çekiliş'),
        backgroundColor: const Color(0xFF330066),
        foregroundColor: Colors.white,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
          gradient: const LinearGradient(
            colors: [AppColors.darkPurple, AppColors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: _GachaPageContents(
            milestones: milestones,
            currentPoints: currentPoints,
            maxPoints: maxPoints,
            collectedChests: collectedChests,
            items: items,
          ),
        ),
      ),
      floatingActionButton: _GachaPageButtons(),
    );
  }
}

class _GachaPageButtons extends StatelessWidget {
  const _GachaPageButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 50,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: spin(context),
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.shuffle),
        ),
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
    super.key,
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
  final List<GameItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        GachaHud(),
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
        AnimatedGridBoxWithProvider(gameItems: items),
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
