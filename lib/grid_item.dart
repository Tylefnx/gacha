import 'package:flutter/material.dart';
import 'package:gacha/app_colors.dart';
import 'package:gacha/game_item.dart';
import 'package:gacha/glow_container.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

class GridItem extends StatefulWidget {
  final int index;
  final GameItem gameItem;

  const GridItem({super.key, required this.index, required this.gameItem});

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );
  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gridState = Provider.of<GridStateNotifier>(context);
    final bool isAnimated = (gridState.animatedBoxIndex == widget.index);

    if (isAnimated) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBaseColor(GameItem item) {
    if (item.bgColor != null) {
      return Color(item.bgColor!);
    }
    // Fallback colors based on index if bgColor is null
    if ([0, 1, 5, 9].contains(widget.index)) {
      return const Color(0xFF3366CC);
    } else if ([4, 8, 12, 13].contains(widget.index)) {
      return const Color(0xFF8A2BE2);
    } else {
      return const Color(0xFFFF8C00);
    }
  }

  Color _getBorderColor(bool isHighlighted, bool isAnimated) {
    if (isHighlighted || isAnimated) {
      return AppColors.yellow;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if ([5, 6, 9, 10].contains(widget.index)) {
      return const SizedBox.shrink();
    }

    final GridStateNotifier gridState = Provider.of<GridStateNotifier>(context);
    final bool isHighlighted = (gridState.highlightedBoxIndex == widget.index);
    final bool isAnimated = (gridState.animatedBoxIndex == widget.index);

    final Color baseColor = _getBaseColor(widget.gameItem);
    final Color borderColor = _getBorderColor(isHighlighted, isAnimated);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GlowContainer(
        baseColor: baseColor,
        borderColor: borderColor,
        isAnimated: isAnimated,
        isHighlighted: isHighlighted,
        child: GridContent(gameItem: widget.gameItem),
      ),
    );
  }
}

class GridContent extends StatelessWidget {
  final GameItem gameItem;

  const GridContent({required this.gameItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (gameItem.image != null)
          Image.asset(
            gameItem.image!,
            fit: BoxFit.contain,
            width: 50,
            height: 50,
          )
        else
          const Icon(Icons.category, size: 50, color: Colors.white54),
      ],
    );
  }
}
