
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/system_alert/line_hint.dart';


class FrameWinBg extends SpriteComponent with TapCallbacks{
  final String score;
  final String bettingOdds;

  FrameWinBg({required this.score,required this.bettingOdds}) : super(anchor: Anchor.center);

  late TextComponent contentTextComponent;

  late ScaleEffect scaleEffect;
  @override
  void onLoad() async {
    //缩放效果
    scaleEffect = ScaleEffect.by(
      Vector2.all(1.2),
      EffectController(duration: 0.3),
    );
    sprite = await Sprite.load('win_hint/frame_win_bg.png');
    add(scaleEffect);

    contentTextComponent = TextComponent(
      textRenderer: TextPaint(
        style : const TextStyle(
          fontSize: 50,
          color: Color.fromRGBO(237, 168, 43, 1)
        )
      ),
      text: score,
      anchor: Anchor.center,
      position: Vector2(150,55),
      priority: 2
    );
    add(contentTextComponent);


    add(LineHint(block: 'block', bettingOdds: bettingOdds, lines: '3',score: score));

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}