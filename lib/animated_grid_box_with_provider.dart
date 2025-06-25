import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

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
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 15,
            inset: true,
            offset: const Offset(4, 4),
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
                  child: Image.asset(
                    'assets/gift.png',
                    fit: BoxFit.cover,
                    width: centerBoxSize / 2,
                    height: centerBoxSize / 2,
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

  Color _getBaseColor(int index) {
    if ([0, 1, 5, 9].contains(index)) {
      return const Color(0xFF3366CC);
    } else if ([4, 8, 12, 13].contains(index)) {
      return const Color(0xFF8A2BE2);
    } else {
      return const Color(0xFFFF8C00);
    }
  }

  Color _getBorderColor(bool isHighlighted, bool isAnimated) {
    if (isHighlighted || isAnimated) return Colors.yellow;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final gridState = Provider.of<GridStateNotifier>(context);
    final isHighlighted = (gridState.highlightedBoxIndex == widget.index);
    final isAnimated = (gridState.animatedBoxIndex == widget.index);

    if ([5, 6, 9, 10].contains(widget.index)) return const SizedBox.shrink();

    final baseColor = _getBaseColor(widget.index);
    final borderColor = _getBorderColor(isHighlighted, isAnimated);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GlowContainer(
        baseColor: baseColor,
        borderColor: borderColor,
        child: GridContent(index: widget.index),
      ),
    );
  }
}

class GlowContainer extends StatelessWidget {
  final Color borderColor;
  final Color baseColor;
  final Widget child;

  const GlowContainer({
    required this.borderColor,
    required this.baseColor,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, baseColor],
          radius: 0.5,
        ),
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.7),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class GridContent extends StatelessWidget {
  final int index;

  const GridContent({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/card.png',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
    );
  }
}
