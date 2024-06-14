
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class BigWinLineHint extends SpriteComponent with TapCallbacks{
  String score;

  BigWinLineHint({required this.score}) : super(anchor: Anchor.center, position: Vector2(0, 0),scale: Vector2(0.6,0.6));

  @override
  void onLoad() async {
    sprite = await Sprite.load('/win_hint/big_win_line_hint.png');
    add(TextComponent(
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 100,
                // fontSize: 200,
                color: Color.fromRGBO(237, 168, 43, 1)
            )
        ),
        text: score,
        anchor: Anchor.center,
        position: Vector2(560,255),
        priority: 2
    ));


    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
