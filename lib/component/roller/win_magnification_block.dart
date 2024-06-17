import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/symbol/enum.dart';


class WinMagnificationBlock extends SpriteComponent {
  String image;

  WinMagnificationBlock({required this.image}) : super(size: Vector2(125,93), position: Vector2(147,8));


  MoveEffect? moveEffect;

  late RectangleComponent rectangleComponent;

  @override
  void onLoad() async {
    sprite = await Sprite.load(image);

    super.onLoad();
  }

  Future<void> addMask() async {
    await add(rectangleComponent);

  }

  void removeMask(){
    Future.delayed(const Duration(milliseconds: 50), () {
      remove(rectangleComponent);
    });
  }

}
