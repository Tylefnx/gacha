import 'package:flutter/material.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

class AnimatedGridBoxWithProvider extends StatefulWidget {
  const AnimatedGridBoxWithProvider({super.key});

  @override
  State<AnimatedGridBoxWithProvider> createState() =>
      _AnimatedGridBoxWithProviderState();
}

class _AnimatedGridBoxWithProviderState
    extends State<AnimatedGridBoxWithProvider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  BoxDecoration _getBoxDecoration(
    int index,
    bool isHighlighted,
    bool isAnimated,
  ) {
    Color outerBorderBaseColor = Colors.white.withOpacity(0.3);
    List<Color> gradientColors;
    Color outerBorderColor = outerBorderBaseColor;

    if ([0, 1, 5, 9].contains(index)) {
      gradientColors = [const Color(0xFF3366CC), const Color(0xFF4A90E2)];
    } else if ([4, 8, 12, 13].contains(index)) {
      gradientColors = [const Color(0xFF8A2BE2), const Color(0xFF9966CC)];
    } else {
      gradientColors = [const Color(0xFFFF8C00), const Color(0xFFFFA500)];
    }

    if (isHighlighted) {
      gradientColors = [Colors.yellow.shade300, Colors.yellow.shade600];
      outerBorderColor = Colors.white;
    }

    if (isAnimated) {
      outerBorderColor = Colors.greenAccent;
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: outerBorderColor, width: 3.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
        if (isHighlighted || isAnimated)
          BoxShadow(
            color: isHighlighted
                ? Colors.yellow.withOpacity(0.7)
                : Colors.greenAccent.withOpacity(0.7),
            spreadRadius: 4,
            blurRadius: 15,
            offset: Offset.zero,
          ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    final gridState = Provider.of<GridStateNotifier>(context);
    final bool isCenterBox = ([5, 6, 9, 10].contains(index));
    final bool isAnimated = (gridState.animatedBoxIndex == index);
    final bool isHighlighted = (gridState.highlightedBoxIndex == index);

    if (isCenterBox) return const SizedBox.shrink();

    Widget itemContent = GridContent(
      gridStateNotifier: gridState,
      index: index,
    );

    Widget boxContainer = Container(
      margin: const EdgeInsets.all(6.0),
      decoration: _getBoxDecoration(index, isHighlighted, isAnimated),
      child: itemContent,
    );

    if (isAnimated) {
      _animationController.forward(from: 0.0);
      return ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.15).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        ),
        child: boxContainer,
      );
    } else {
      return boxContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double gridWidth = constraints.maxWidth.clamp(300.0, 600.0);
          const double margin = 12.0;
          const double itemCountPerRow = 4;
          final double itemSize =
              (gridWidth - (itemCountPerRow * margin)) / itemCountPerRow;
          final double centerBoxSize = (itemSize * 2) + margin;

          return Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFF330066),
              borderRadius: BorderRadius.circular(36.0),
              border: Border.all(color: Color(0xffAF97DC), width: 3.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  spreadRadius: -5,
                  blurRadius: 15,
                ),
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
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF200040),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1.0,
                            ),
                        itemCount: 16,
                        itemBuilder: (context, index) {
                          return _buildGridItem(context, index);
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: centerBoxSize,
                      height: centerBoxSize,
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.card_giftcard,
                              size: centerBoxSize * 0.6,
                              color: Colors.white70,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridContent extends StatelessWidget {
  const GridContent({
    super.key,
    required this.gridStateNotifier,
    required this.index,
  });

  final GridStateNotifier gridStateNotifier;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        gridStateNotifier.getBoxImageUrl(index),
        fit: BoxFit.contain,
        width: 70,
        height: 70,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: Colors.white70,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.white54, size: 40),
      ),
    );
  }
}
