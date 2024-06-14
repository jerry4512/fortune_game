
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/symbol/calculate/calculate_win.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';


class LineHint extends SpriteComponent with TapCallbacks{
  String block;
  String bettingOdds;
  String lines;
  String score;

  LineHint({required this.block,required this.bettingOdds,required this.lines,required this.score}) : super(anchor: Anchor.center, position: Vector2(0, 200),scale: Vector2(0.7,0.7));

  List<String> magnificationBlockList = [];

  String blockImage = '';
  String magnificationImage = '';

  @override
  void onLoad() async {
    random();
    sprite = await Sprite.load('win_hint/line_hint.png');
    opacity = 0.0;

    add(SpriteComponent(
        sprite: await Sprite.load(blockImage),
        anchor: Anchor.center,
        position: Vector2(140,35),
    ));

    add(OpacityEffect.fadeIn(
      EffectController(duration: 0.5),
    ));

    add(TextComponent(
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(237, 168, 43, 1)
            )
        ),
        text: '${bettingOdds}X $lines',
        anchor: Anchor.center,
        position: Vector2(230,35),
        priority: 2,
    ));

    add(SpriteComponent(
        sprite: await Sprite.load('/win_hint/line_hint_text.png'),
        anchor: Anchor.center,
        position: Vector2(350,35),
    ));

    add(TextComponent(
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(237, 168, 43, 1)
            )
        ),
        text: ' X',
        anchor: Anchor.center,
        position: Vector2(410,35),
        priority: 2
    ));

    add(SpriteComponent(
        sprite: await Sprite.load(magnificationImage),
        anchor: Anchor.center,
        position: Vector2(480,35)
    ));

    add(TextComponent(
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(237, 168, 43, 1)
            )
        ),
        text: '= $score',
        anchor: Anchor.center,
        position: Vector2(580,35),
        priority: 2
    ));


    // final effect = OpacityEffect.to(
    //   0.2,
    //   EffectController(duration: 0.75),
    // );

    // add(effect);

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

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
