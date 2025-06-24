import 'package:flutter/material.dart';
import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

class GachaPage extends StatelessWidget {
  const GachaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tasarım Odaklı Grid'),
        backgroundColor: const Color(0xFF330066),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFF330066), Color(0xFF6A0DAD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.question_mark_rounded, color: Colors.white),
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
              ),
            ),
            AnimatedGridBoxWithProvider(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<GridStateNotifier>(
            context,
            listen: false,
          ).startSpinningAndSelect();
        },
        tooltip: 'Rastgele kutu seç ve canlandır',
        backgroundColor: const Color(0xFF6A0DAD),
        foregroundColor: Colors.white,
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}
