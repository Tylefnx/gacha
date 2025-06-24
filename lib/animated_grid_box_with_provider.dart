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
  late AnimationController
  _animationController; // Nihai animasyon için kontrolcü

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700), // Nihai animasyon süresi
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildGridItem(BuildContext context, int index) {
    final gridState = Provider.of<GridStateNotifier>(context);
    final bool isCenterBox = ([5, 6, 9, 10].contains(index));
    final bool isAnimated = (gridState.animatedBoxIndex == index);
    final bool isHighlighted =
        (gridState.highlightedBoxIndex == index); // Yeni vurgu kontrolü

    if (isCenterBox) {
      return const SizedBox.shrink();
    }

    // Kutucuğun temel içeriği
    Widget boxContent = Container(
      decoration: BoxDecoration(
        color: isHighlighted
            ? Colors.yellow[200]
            : Colors.blueGrey[100], // Vurgu rengi
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Center(
        child: Image.network(
          gridState.getBoxImageUrl(index),
          fit: BoxFit.cover,
          width: 80,
          height: 80,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.grey, size: 40),
        ),
      ),
    );

    // Eğer bu kutucuk nihai olarak canlandırılacaksa, animasyonu uygula
    if (isAnimated) {
      _animationController.forward(from: 0.0); // Animasyonu başlat
      return ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.15).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        ),
        child: boxContent,
      );
    } else {
      // Eğer highlight ediliyorsa, sadece rengi değiştiği için ek bir animasyon widgetına gerek yok.
      // Ya da turlama için de hafif bir animasyon eklenebilir (örn: Opacity)
      return boxContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelişmiş 4x4 Grid Widget'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return _buildGridItem(context, index);
                },
              ),
              Positioned(
                top: MediaQuery.of(context).size.width / 4,
                left: MediaQuery.of(context).size.width / 4,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://via.placeholder.com/300/FF0000/FFFFFF?text=MERKEZ',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Merkez',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Turlama ve seçimi başlatacak yeni metodu çağır
          Provider.of<GridStateNotifier>(
            context,
            listen: false,
          ).startSpinningAndSelect();
          _animationController.reset(); // Nihai animasyon kontrolcüsünü sıfırla
        },
        tooltip: 'Rastgele kutu seç ve canlandır',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}
