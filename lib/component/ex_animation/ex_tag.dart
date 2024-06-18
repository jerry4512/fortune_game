
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class ExTag extends SpriteComponent{


  ExTag() : super(anchor: Anchor.centerLeft, position: Vector2(120,55), size: Vector2(0,0));

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/ex_button.png');

    SizeEffect sizeEffect = SizeEffect.to(
      Vector2(45,30),
      EffectController(duration: 1,curve: Curves.easeOutBack),
    );

    add(sizeEffect);

    super.onLoad();
  }

}
