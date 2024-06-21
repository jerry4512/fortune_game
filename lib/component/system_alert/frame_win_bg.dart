
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/sprite_number_component/sprite_number_component.dart';


class FrameWinBg extends SpriteComponent with TapCallbacks{
  final String score;
  final String bettingOdds;

  FrameWinBg({required this.score,required this.bettingOdds}) : super(anchor: Anchor.center,position: Vector2(-60,55));

  late TextComponent contentTextComponent;

  late ScaleEffect scaleEffect;
  late OpacityEffect opacityEffect;
  late OpacityProvider opacityProvider;
  @override
  void onLoad() async {
    sprite = await Sprite.load('win_hint/frame_win_bg.png');
    //缩放效果
    scaleEffect = ScaleEffect.by(
      Vector2.all(1.2),
      EffectController(duration: 0.3),
    );
    add(scaleEffect);

    add(SpriteNumberComponent(
      srcDirPath: 'image_numbers/total_score_numbers',
      anchor: Anchor.center,
      position: Vector2(150,55),
      initNum: int.parse(score),
    ));

    Future.delayed(const Duration(seconds: 3), () {
      removeFromParent();
    });

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
