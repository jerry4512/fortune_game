
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class LineHint extends SpriteComponent with TapCallbacks{
  String block;
  String bettingOdds;
  String lines;

  LineHint({required this.block,required this.bettingOdds,required this.lines}) : super(anchor: Anchor.center, position: Vector2(150, 200),scale: Vector2(0.7,0.7));

  @override
  void onLoad() async {
    sprite = await Sprite.load('/win_hint/line_hint.png');
    add(TextComponent(
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(237, 168, 43, 1)
            )
        ),
        text: '${bettingOdds}X $lines',
        anchor: Anchor.center,
        position: Vector2(150,35),
        priority: 2
    ));

    add(SpriteComponent(
        sprite: await Sprite.load('/win_hint/line_hint_text.png'),
        anchor: Anchor.center,
        position: Vector2(270,35)
    ));

    add(TextComponent(
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(237, 168, 43, 1)
            )
        ),
        text: 'X',
        anchor: Anchor.center,
        position: Vector2(330,35),
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
