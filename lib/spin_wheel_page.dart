import 'package:flutter/material.dart';
import 'package:gacha/item.dart';
import 'package:gacha/spin_wheel_provider.dart';
import 'package:provider/provider.dart';

class SpinWheelPage extends StatelessWidget {
  const SpinWheelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpinWheelProvider(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Carkı Çevir'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Consumer<SpinWheelProvider>(
          builder: (context, provider, _) => Column(
            spacing: 20,
            children: [
              Text(
                'Bugün kalan deneme sayısı: ${provider.remainingSpins}',
                style: const TextStyle(color: Colors.white),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return SpinWheelWidget(
                      item: provider.items[index],
                      selected: provider.selectedIndex == index,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => provider.spinOnce(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('1 Kez Döndür'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('10 Kez Döndür'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpinWheelWidget extends StatelessWidget {
  const SpinWheelWidget({
    super.key,
    required this.item,
    required this.selected,
  });

  final GameItem item;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(item.bgColor ?? 0xFF333333),
        border: Border.all(
          color: selected ? Colors.yellow : Colors.black,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.imageFile != null)
                Image.asset(item.imageFile!, height: 40)
              else
                const Icon(Icons.card_giftcard, size: 40, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                item.name ?? '-',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              Text(
                '${item.quantity ?? 0}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
