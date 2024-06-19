import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/system_alert/confirm_button.dart';


class SystemExplanation extends SpriteComponent with TapCallbacks{

  SystemExplanation() : super(anchor: Anchor.center);

  late TextComponent content;

  @override
  void onLoad() async {
    sprite = await Sprite.load('extra_intro_bg.png');
    position = Vector2(0, -300);
    scale = Vector2(1.8, 1.8);

    content = TextComponent(
      position: Vector2(168,35),
      anchor: Anchor.center,
      textRenderer: TextPaint(
          style : const TextStyle(
              fontSize: 11.5,
              color: Colors.white
          )
      ),
      text: 'Extra bets need to pay an additional 50% of the betting amount.\nUpon activation:\nWin multiplier are guaranteed to be at least 2 times, with\nsignificantly increased chances of other multiplier.'
    );

    add(content);

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
