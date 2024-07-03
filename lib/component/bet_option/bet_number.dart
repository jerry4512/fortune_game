import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:fortune_game/symbol/parameter.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

typedef OnTap = void Function(String);

class BetNumber extends TextComponent with TapCallbacks{

  final OnTap onTap;
  String number;
  Vector2 numberPosition;
  BetNumber({required this.onTap,required this.number,required this.numberPosition}) : super();

  @override
  void onLoad() async {
    text = number;
    anchor = Anchor.topCenter;
    scale = Vector2(0.8,0.8);
    position = numberPosition;
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
      text = betNumberInt.toString();
    }else{
      text = number;
    }
  }
}
