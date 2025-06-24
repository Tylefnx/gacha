import 'package:flutter/material.dart';
import 'package:gacha/animated_grid_box_with_provider.dart';
import 'package:gacha/grid_state_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GridStateNotifier(),
      child: MaterialApp(
        home: AnimatedGridBoxWithProvider(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

// Ana widget
