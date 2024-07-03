import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/component/bet_option/bet_number.dart';
import 'package:fortune_game/symbol/parameter.dart';

typedef OnTap = void Function(String);

class BetButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;
  BetButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(-130,280),size: Vector2(50,50),priority: 2);

  late SpriteComponent spriteComponent;

  List<Component> components = [];

  bool isPressed = false;

  String betNumber = '3';

  late TextComponent textComponent;

  List<String> betNumberList = ['1000', '200', '8', '700', '100', '5', '500', '50', '3', '400', '20', '2', '300', '10', '1'];
  List<Vector2> betNumberPositionList = [Vector2(-65, -275), Vector2(25, -275), Vector2(112, -275), Vector2(-65, -220), Vector2(25, -220), Vector2(112, -220), Vector2(-65, -165), Vector2(25, -165), Vector2(112, -165), Vector2(-65, -110), Vector2(25, -110), Vector2(112, -110), Vector2(-65, -55), Vector2(25, -55), Vector2(112, -55)];

  //选中框
  late RectangleComponent rectangleComponent;

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/icon_bet.png');
    init();

    textComponent = TextComponent(
      text: 'Bet $betNumber',
      position: Vector2(-1, 50),
      size: Vector2(50, 20),
      scale: Vector2(0.9,0.9),
    );

    add(textComponent);

    // rectangleComponent = RectangleComponent(size: Vector2(86, 57), position: Vector2(betNumberPositionList[betNumberList.indexOf(betNumber)].x,betNumberPositionList[betNumberList.indexOf(betNumber)].y+13), anchor: Anchor.center, paint: Paint()..color = Colors.yellow.withOpacity(0.5));

    super.onLoad();
  }

  Future<void> init() async {
    spriteComponent = SpriteComponent(
        sprite: await Sprite.load('bet_options_frame_l.png'),
        anchor: Anchor.bottomCenter,
        scale: Vector2(0.45,0.45),
        position: Vector2(25,-10)
    );
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[0], numberPosition: betNumberPositionList[0]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[1], numberPosition: betNumberPositionList[1]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[2], numberPosition: betNumberPositionList[2]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[3], numberPosition: betNumberPositionList[3]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[4], numberPosition: betNumberPositionList[4]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[5], numberPosition: betNumberPositionList[5]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[6], numberPosition: betNumberPositionList[6]));
    components.add((BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[7], numberPosition: betNumberPositionList[7])));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[8], numberPosition: betNumberPositionList[8]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[9], numberPosition: betNumberPositionList[9]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[10], numberPosition: betNumberPositionList[10]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[11], numberPosition: betNumberPositionList[11]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[12], numberPosition: betNumberPositionList[12]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[13], numberPosition: betNumberPositionList[13]));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: betNumberList[14], numberPosition: betNumberPositionList[14]));
  }

  void betNumberOnTap(String number){
    isPressed = !isPressed;
    betNumber = number;
    remove(textComponent);
    textComponent = TextComponent(
      text: 'Bet $betNumber',
      position: Vector2(-1, 50),
      size: Vector2(50, 20),
      scale: Vector2(0.9,0.9),
    );
    add(textComponent);
    remove(spriteComponent);
    // rectangleComponent.removeFromParent();
    removeAll(components);
    onTap(betNumber);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isPressed = !isPressed;
    if(isPressed){
      add(spriteComponent);
      // add(rectangleComponent);
      addAll(components);
    }else{
      remove(spriteComponent);
      // rectangleComponent.removeFromParent();
      removeAll(components);
    }

  }


  @override
  void update(double dt) {
    if(Parameter.isOpenExMode){
      remove(textComponent);
      double betNumberDouble = double.parse(betNumber);
      double newBetNumber = betNumberDouble*1.5;
      textComponent = TextComponent(
        text: 'Bet $newBetNumber',
        position: Vector2(-1, 50),
        size: Vector2(50, 20),
        scale: Vector2(0.9,0.9),
      );
      add(textComponent);
    }else{
      remove(textComponent);
      textComponent = TextComponent(
        text: 'Bet $betNumber',
        position: Vector2(-1, 50),
        size: Vector2(50, 20),
        scale: Vector2(0.9,0.9),
      );
      add(textComponent);
    }
    // rectangleComponent = RectangleComponent(size: Vector2(86, 57), position: Vector2(betNumberPositionList[betNumberList.indexOf(betNumber)].x,betNumberPositionList[betNumberList.indexOf(betNumber)].y+13), anchor: Anchor.center, paint: Paint()..color = Colors.yellow.withOpacity(0.5));

  }
}
