// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/dots_row.dart';
import 'package:gacha/game_item.dart';
import 'package:gacha/grid_item.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

class AnimatedGridBoxWithProvider extends StatelessWidget {
  final List<GameItem> gameItems;

  const AnimatedGridBoxWithProvider({super.key, required this.gameItems});

  @override
  Widget build(BuildContext context) {
    final gridStateNotifier = Provider.of<GridStateNotifier>(
      context,
      listen: false,
    );
    final List<int> availableGridIndices = gridStateNotifier.availableIndices;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gridWidth = constraints.maxWidth.clamp(300.0, 600.0);
          const margin = 12.0;
          const itemCountPerRow = 4;
          final itemSize =
              (gridWidth - (itemCountPerRow * margin)) / itemCountPerRow;
          final centerBoxSize = (itemSize * 2) + margin;

          return MainGridContainer(
            centerBoxSize: centerBoxSize,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemCountPerRow,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                if ([5, 6, 9, 10].contains(index)) {
                  return const SizedBox.shrink();
                }

                final int availableIndexInList = availableGridIndices.indexOf(
                  index,
                );

                if (availableIndexInList != -1) {
                  final GameItem item =
                      gameItems[availableIndexInList % gameItems.length];
                  return GridItem(index: index, gameItem: item);
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

class MainGridContainer extends StatelessWidget {
  final double centerBoxSize;
  final Widget child;

  const MainGridContainer({
    required this.centerBoxSize,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1C53),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 12.8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: MainGridContainerContents(
        centerBoxSize: centerBoxSize,
        child: child,
      ),
    );
  }
}

class MainGridContainerContents extends StatelessWidget {
  const MainGridContainerContents({
    super.key,
    required this.child,
    required this.centerBoxSize,
  });

  final Widget child;
  final double centerBoxSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1953).withOpacity(0.2),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppColors.purpleAccent, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.whitishPurple.withOpacity(0.7),
            blurRadius: 12.8,
            offset: const Offset(6, 6),
            inset: true,
          ),
          BoxShadow(
            color: AppColors.lightPurple.withOpacity(0.7),
            blurRadius: 12.8,
            inset: true,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF200040),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: child),
            ),
            Align(child: MainGridContainerCenter(centerBoxSize: centerBoxSize)),
          ],
        ),
      ),
    );
  }
}

class MainGridContainerCenter extends StatelessWidget {
  const MainGridContainerCenter({super.key, required this.centerBoxSize});

  final double centerBoxSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: centerBoxSize,
      height: centerBoxSize,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              DotsRow.lightThenPlain(),
              const SizedBox(height: 5),
              Image.asset(
                'assets/gift.png',
                fit: BoxFit.cover,
                width: centerBoxSize / 2,
                height: centerBoxSize / 2,
              ),
              const SizedBox(height: 5),
              DotsRow.plainThenLight(),
            ],
          ),
        ),
      ),
    );
  }
}
