import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/system_alert/big_win_line_hint.dart';
import 'package:fortune_game/component/system_alert/confirm_button.dart';


class SuperWin extends PositionComponent with TapCallbacks{

  String score;

  SuperWin({required this.score}) : super(anchor: Anchor.center, priority: 2);

  late ScaleEffect scaleEffect;
  late MoveEffect moveEffect;
  late SpriteComponent spriteComponent;

  @override
  void onLoad() async {

    scaleEffect = ScaleEffect.to(Vector2(1.2,1.2),RepeatedEffectController(LinearEffectController(1), 6));
    spriteComponent = SpriteComponent(
      sprite: await Sprite.load('win_hint/super_win.png'),
      anchor: Anchor.bottomCenter,
    );
    spriteComponent.add(scaleEffect);

    add(RectangleComponent(size: Vector2(1600, 1600), anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5)));

    add(spriteComponent);

    add(BigWinLineHint(score: score));



    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
