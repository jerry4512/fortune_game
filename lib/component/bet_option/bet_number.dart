import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

typedef OnTap = void Function(String);

class BetNumber extends PositionComponent with TapCallbacks{

  final OnTap onTap;
  String number;
  Vector2 numberPosition;
  BetNumber({required this.onTap,required this.number,required this.numberPosition}) : super();

  @override
  void onLoad() async {

    add(TextComponent(
      anchor: Anchor.topCenter,
      text: number,
      scale: Vector2(0.8,0.8),
      position: numberPosition,
    ));
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap(number);
  }


}
