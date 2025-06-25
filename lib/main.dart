import 'package:flutter/material.dart';
import 'package:gacha/gacha_page.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GridStateNotifier(),
      child: MaterialApp(home: GachaPage(), debugShowCheckedModeBanner: false),
    ),
  );
}

// Ana widget
