
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/sprite_number_component/sprite_number_component.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';


class LineHint extends SpriteComponent with TapCallbacks{
  String block;
  String bettingOdds;
  String lines;
  String score;

  LineHint({required this.block,required this.bettingOdds,required this.lines,required this.score}) : super(anchor: Anchor.center, position: Vector2(-60, 200),scale: Vector2(0.8,0.8));

  List<String> magnificationBlockList = [];

  String blockImage = '';
  String magnificationImage = '';

  double x1Position = 215;

  @override
  void onLoad() async {
    random();
    sprite = await Sprite.load('win_hint/line_hint.png');
    opacity = 0.0;

    //方块图片
    add(SpriteComponent(
        sprite: await Sprite.load(blockImage),
        anchor: Anchor.center,
        position: Vector2(100,35),
    ));

    //淡入效果
    add(OpacityEffect.fadeIn(
      EffectController(duration: 0.1),
    ));

    //压注额
    add(SpriteNumberComponent(
      srcDirPath: 'image_numbers/compensation_numbers',
      anchor: Anchor.centerLeft,
      position: Vector2(160,35),
      initNum: int.parse(bettingOdds),
    ));


    //乘号
    add(SpriteComponent(
      sprite: await Sprite.load('image_numbers/compensation_numbers/x.png'),
      anchor: Anchor.centerLeft,
      position: getX1Position(),
    ));

    // //连线数
    add(SpriteNumberComponent(
      srcDirPath: 'image_numbers/compensation_numbers',
      anchor: Anchor.centerLeft,
      position: getLinePosition(),
      initNum: int.parse(lines),
    ));

    //连线文字图片
    add(SpriteComponent(
        sprite: await Sprite.load('/win_hint/line_hint_text.png'),
        anchor: Anchor.centerLeft,
        position: getLineTextPosition(),
    ));

    //乘号
    add(SpriteComponent(
      sprite: await Sprite.load('image_numbers/compensation_numbers/x.png'),
      anchor: Anchor.centerLeft,
      position: getX2Position(),
    ));

    //倍率图片
    add(SpriteComponent(
        sprite: await Sprite.load(magnificationImage),
        anchor: Anchor.centerLeft,
        position: getMagnificationPosition()
    ));

    //乘号
    add(SpriteComponent(
      sprite: await Sprite.load('image_numbers/compensation_numbers/=.png'),
      anchor: Anchor.center,
      position: getEqualPosition()
    ));

    //得分
    add(SpriteNumberComponent(
      srcDirPath: 'image_numbers/compensation_numbers',
      anchor: Anchor.centerLeft,
      position: getScorePosition(),
      initNum: int.parse(score),
    ));


    super.onLoad();
  }

  Vector2 getX1Position(){
    switch(bettingOdds.length){
      case 1:
        x1Position = 195;
        break;
      case 2:
        x1Position = 230;
        break;
      case 3:
        x1Position = 265;
        break;
      case 4:
        x1Position = 300;
        break;
    }
    return Vector2(x1Position,35);
  }

  Vector2 getLinePosition(){
    double linePosition = 0;
    switch(bettingOdds.length){
      case 1:
        linePosition = 245;
        break;
      case 2:
        linePosition = 280;
        break;
      case 3:
        linePosition = 315;
        break;
      case 4:
        linePosition = 350;
        break;
    }
    return Vector2(linePosition,35);
  }

  Vector2 getLineTextPosition(){
    double lineTextPosition = 0;
    switch(bettingOdds.length){
      case 1:
        lineTextPosition = 285;
        break;
      case 2:
        lineTextPosition = 320;
        break;
      case 3:
        lineTextPosition = 355;
        break;
      case 4:
        lineTextPosition = 390;
        break;
    }
    return Vector2(lineTextPosition,35);
  }

  Vector2 getX2Position(){
    double x2Position = 0;
    switch(bettingOdds.length){
      case 1:
        x2Position = 385;
        break;
      case 2:
        x2Position = 420;
        break;
      case 3:
        x2Position = 455;
        break;
      case 4:
        x2Position = 490;
        break;
    }
    return Vector2(x2Position,35);
  }

  Vector2 getMagnificationPosition(){
    double magnificationPosition = 0;
    switch(bettingOdds.length){
      case 1:
        magnificationPosition = 430;
        break;
      case 2:
        magnificationPosition = 470;
        break;
      case 3:
        magnificationPosition = 505;
        break;
      case 4:
        magnificationPosition = 540;
        break;
    }
    return Vector2(magnificationPosition,35);
  }

  Vector2 getEqualPosition(){
    double equalPosition = 0;
    switch(bettingOdds.length){
      case 1:
        equalPosition = 520;
        break;
      case 2:
        equalPosition = 560;
        break;
      case 3:
        equalPosition = 600;
        break;
      case 4:
        equalPosition = 630;
        break;
    }
    return Vector2(equalPosition,35);
  }

  Vector2 getScorePosition(){
    double scorePosition = 0;
    switch(bettingOdds.length){
      case 1:
        scorePosition = 550;
        break;
      case 2:
        scorePosition = 585;
        break;
      case 3:
        scorePosition = 635;
        break;
      case 4:
        scorePosition = 655;
        break;
    }
    return Vector2(scorePosition,35);
  }

  void random(){
    Random random = Random();
    int blocksIndex = random.nextInt(SymbolBlocks().winLineHintBlocks.length);
    int magnificationIndex = random.nextInt(SymbolBlocks().winLineHintMagnifications.length);
    blockImage = SymbolBlocks().winLineHintBlocks[blocksIndex];
    magnificationImage = SymbolBlocks().winLineHintMagnifications[magnificationIndex];

  }


  @override
  void update(double dt) {

  }

}
