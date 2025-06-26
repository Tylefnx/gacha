import 'package:flutter/material.dart';
import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/gift_box_row.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:gacha/reward_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:gacha/game_item.dart';

class GachaPage extends StatelessWidget {
  const GachaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPoints = 80;
    final List<GameItem> mockItems = getMockGameItems();

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
          child: Column(
            spacing: 7.5,
            children: [
              GachaHud(),
              GiftBoxRow(
                milestones: [40, 80, 120, 160],
                currentPoints: currentPoints,
                maxPoints: 75,
                collectedChests: 44,
              ),
              RewardProgressBarWithMilestones(
                currentPoints: currentPoints,
                milestones: [40, 80, 120, 160],
              ),
              AnimatedGridBoxWithProvider(gameItems: mockItems),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
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
      ),
    );
  }
}

class GachaHud extends StatelessWidget {
  const GachaHud({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(Icons.question_mark, color: Colors.black),
            ),
            Text(
              'Şanslı Çekiliş',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ColoredBox(
          color: Colors.white,
          child: SizedBox(width: 100, height: 10),
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
