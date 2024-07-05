import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

typedef OnTap = void Function();

class SpinButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  SpinButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(0,265), size: Vector2(80,80));

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/spin_button.png');

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }


  @override
  void update(double dt) {

  }

}
