import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

typedef OnTap = void Function();

class GameViewClipComponent extends RectangleComponent with TapCallbacks{
  final OnTap onTap;
  GameViewClipComponent({required this.onTap}) : super(position: Vector2(0,50));


  @override
  void onLoad() async {
    size =  Vector2(550, 300);
    anchor =  Anchor.center;
    paint = Paint()..color = Colors.transparent;

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

}
