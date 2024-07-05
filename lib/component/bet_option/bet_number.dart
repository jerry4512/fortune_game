import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/symbol/parameter.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

typedef OnTap = void Function(String);

class BetNumber extends PositionComponent with TapCallbacks{

  final OnTap onTap;
  String number;
  Vector2 numberPosition;
  BetNumber({required this.onTap,required this.number,required this.numberPosition}) : super(size: Vector2(88, 57),anchor: Anchor.bottomCenter);

  TextComponent? textComponent;

  @override
  void onLoad() async {
    priority = 2;
    position = numberPosition;
    textComponent = TextComponent(
        text: number,
        scale: Vector2(0.8,0.8),
        position: Vector2(43, 30),
        anchor : Anchor.center
    );

    add(textComponent!);

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap(number);
  }

  @override
  void update(double dt) {
    if(Parameter.isOpenExMode){
      double betNumberInt = double.parse(number);
      betNumberInt = betNumberInt*1.5;
      changeNumber(betNumberInt.toString());
    }else{
      changeNumber(number);
    }
  }

  void changeNumber(String text){
    remove(textComponent!);
    textComponent = TextComponent(
        text: text,
        scale: Vector2(0.8,0.8),
        position: Vector2(43, 30),
        anchor : Anchor.center);
    add(textComponent!);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
