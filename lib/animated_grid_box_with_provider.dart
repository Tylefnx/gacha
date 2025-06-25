import 'package:flutter/material.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

class AnimatedGridBoxWithProvider extends StatelessWidget {
  const AnimatedGridBoxWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
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
                childAspectRatio: 1.0,
              ),
              itemCount: 16,
              itemBuilder: (context, index) => GridItem(index: index),
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF330066),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: const Color(0xffAF97DC), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF200040),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: child),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: centerBoxSize,
                height: centerBoxSize,
                child: Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: centerBoxSize * 0.6,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatefulWidget {
  final int index;

  const GridItem({required this.index, super.key});

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
    final isAnimated = (gridState.animatedBoxIndex == widget.index);

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

  Color _getGlowColor(int index, bool isHighlighted, bool isAnimated) {
    if (isHighlighted) return Colors.yellow;
    if (isAnimated) return Colors.greenAccent;

    if ([0, 1, 5, 9].contains(index)) {
      return const Color(0xFF3366CC);
    } else if ([4, 8, 12, 13].contains(index)) {
      return const Color(0xFF8A2BE2);
    } else {
      return const Color(0xFFFF8C00);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridState = Provider.of<GridStateNotifier>(context);
    final isHighlighted = (gridState.highlightedBoxIndex == widget.index);
    final isAnimated = (gridState.animatedBoxIndex == widget.index);

    if ([5, 6, 9, 10].contains(widget.index)) return const SizedBox.shrink();

    final glowColor = _getGlowColor(widget.index, isHighlighted, isAnimated);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GlowContainer(
        color: glowColor,
        child: GridContent(index: widget.index),
      ),
    );
  }
}

class GlowContainer extends StatelessWidget {
  final Color color;
  final Widget child;

  const GlowContainer({required this.color, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: -4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class GridContent extends StatelessWidget {
  final int index;

  const GridContent({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(Icons.abc));
  }
}
