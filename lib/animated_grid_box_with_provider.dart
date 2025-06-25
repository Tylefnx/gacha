import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gacha/grid_state_notifier.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:gacha/game_item.dart'; // GameItem sınıfını dahil et

class AnimatedGridBoxWithProvider extends StatelessWidget {
  final List<GameItem> gameItems;

  const AnimatedGridBoxWithProvider({super.key, required this.gameItems});

  @override
  Widget build(BuildContext context) {
    // GridStateNotifier'dan kullanılabilir indeksleri doğrudan alalım
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
                childAspectRatio: 1.0,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                // Merkezdeki kutulara öğe geçirmiyoruz
                if ([5, 6, 9, 10].contains(index)) {
                  return const SizedBox.shrink();
                }

                final int actualGridItemIndex = availableGridIndices.indexOf(
                  index,
                );

                if (actualGridItemIndex != -1) {
                  final GameItem item =
                      gameItems[actualGridItemIndex % gameItems.length];
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
// Diğer sınıflar aynı kalır.

class GridItem extends StatefulWidget {
  final int index;
  final GameItem gameItem; // GameItem nesnesini ekledik

  const GridItem({
    required this.index,
    required this.gameItem,
    super.key,
  }); // Constructor'ı güncelledik

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

  Color _getBaseColor(GameItem item) {
    if (item.bgColor != null) {
      return Color(item.bgColor!);
    }
    // Varsayılan renkler, eğer bgColor null ise
    if ([0, 1, 5, 9].contains(widget.index)) {
      return const Color(0xFF3366CC);
    } else if ([4, 8, 12, 13].contains(widget.index)) {
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

    final baseColor = _getBaseColor(widget.gameItem); // GameItem'ı gönderdik
    final borderColor = _getBorderColor(isHighlighted, isAnimated);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GlowContainer(
        baseColor: baseColor,
        borderColor: borderColor,
        isAnimated: isAnimated,
        isHighlighted: isHighlighted,
        child: GridContent(
          gameItem: widget.gameItem,
        ), // GameItem'ı GridContent'e geçirdik
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
    required this.isAnimated,
    required this.isHighlighted,
  });
  final bool isAnimated;
  final bool isHighlighted;
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
        border: (isHighlighted || isAnimated)
            ? GradientBoxBorder(
                width: 3,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.yellow, Colors.deepOrange],
                ),
              )
            : Border.all(color: borderColor, width: 3),
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
          Icon(Icons.category, size: 50, color: Colors.white54),
      ],
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
            color: Colors.black.withValues(alpha: 0.7),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
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
