import 'package:flutter/material.dart' hide BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gacha_hud.dart';
import 'package:gacha/gacha_page_button.dart';
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
      body: Stack(
        children: [
          DecoratedBox(
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
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 65,
              ),
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
          const Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _GachaPageButtons(),
            ),
          ),
        ],
      ),
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
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: GiftBoxRow(
            milestones: milestones,
            currentPoints: currentPoints,
            maxPoints: maxPoints,
            collectedChests: collectedChests,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.5),
          child: RewardProgressBarWithMilestones(
            currentPoints: currentPoints,
            milestones: milestones,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: AnimatedGridBoxWithProvider(gameItems: items),
          ),
        ),
        const SizedBox(height: 30),
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
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinButton(
          imagePath: 'assets/spin_button.png',
          onTap: () => _notifier(context).startSpinningAndSelect(),
        ),
        SpinButton(
          imagePath: 'assets/spin_ten_times_button.png',
          onTap: () => _notifier(context).spinMultipleTimes(10),
        ),
      ],
    );
  }
}
