import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'package:fortune_game/symbol/parameter.dart';


class ExAnimation extends PositionComponent{

  ExAnimation() : super();

  late SpriteComponent magnification_3x;
  late SpriteComponent magnification_5x;
  late SpriteComponent magnification_10x;
  late SpriteComponent magnification_15x;

  @override
  void onLoad() async {
    magnification_3x = SpriteComponent(
        sprite: await Sprite.load('magnifications/magnification_3x.png'),
        size: Vector2(0,0),
        position: Vector2(-350, 100)
    );
    add(magnification_3x);

    SizeEffect sizeEffect_3x = SizeEffect.to(
      Vector2(125,93),
      EffectController(duration: 0.25),
    );
    magnification_3x.add(sizeEffect_3x);

    MoveEffect moveEffect_3x = MoveEffect.to(Vector2(148, -93), EffectController(duration: 0.75, curve: Curves.ease),
    onComplete: (){
      remove(magnification_3x);
    });

    OpacityEffect opacityEffect_3x =OpacityEffect.fadeOut(EffectController(duration: 1.5));
    magnification_3x.add(opacityEffect_3x);
    magnification_3x.add(moveEffect_3x);


    //10倍方块
    Future.delayed(const Duration(milliseconds: 250), () async {
      magnification_10x = SpriteComponent(
          sprite: await Sprite.load('magnifications/magnification_10x.png'),
          size: Vector2(0,0),
          position: Vector2(-350, 100)
      );
      add(magnification_10x);

      SizeEffect sizeEffect_10x = SizeEffect.to(
        Vector2(125,93),
        EffectController(duration: 0.25),
      );
      magnification_10x.add(sizeEffect_10x);

      MoveEffect moveEffect_10x = MoveEffect.to(Vector2(148, 95), EffectController(duration: 0.75, curve: Curves.ease),
          onComplete: (){
            remove(magnification_10x);
      });

      OpacityEffect opacityEffect_10x =OpacityEffect.fadeOut(EffectController(duration: 1.5));
      magnification_10x.add(opacityEffect_10x);
      magnification_10x.add(moveEffect_10x);
    });


    //5倍方块
    Future.delayed(const Duration(milliseconds: 350), () async {
      magnification_5x = SpriteComponent(
          sprite: await Sprite.load('magnifications/magnification_5x.png'),
      size: Vector2(0,0),
      position: Vector2(-350, 100)
      // position: Vector2(148, 8)
      );
      add(magnification_5x);

      SizeEffect sizeEffect_5x = SizeEffect.to(
      Vector2(125,93),
      EffectController(duration: 0.25),
      );
      magnification_5x.add(sizeEffect_5x);

      MoveEffect moveEffect_5x = MoveEffect.to(Vector2(148, 8), EffectController(duration: 0.55, curve: Curves.ease),
          onComplete: () async {
            remove(magnification_5x);
            await Future.delayed(Duration(milliseconds: 500));
            Parameter.isPlayingExAnimation = false;
          });

      OpacityEffect opacityEffect_5x =OpacityEffect.fadeOut(EffectController(duration: 1.5));
      magnification_5x.add(opacityEffect_5x);
      magnification_5x.add(moveEffect_5x);
    });


    //15倍方块
    Future.delayed(const Duration(milliseconds: 450), () async {
      magnification_15x = SpriteComponent(
          sprite: await Sprite.load('magnifications/magnification_15x.png'),
          size: Vector2(0,0),
          position: Vector2(-350, 100)
        // position: Vector2(148, 8)
      );
      add(magnification_15x);

      SizeEffect sizeEffect_15x = SizeEffect.to(
        Vector2(125,93),
        EffectController(duration: 0.25),
      );
      magnification_15x.add(sizeEffect_15x);

      MoveEffect moveEffect_15x = MoveEffect.to(Vector2(148, 105), EffectController(duration: 0.75, curve: Curves.ease),
          onComplete: (){
            remove(magnification_15x);
          });
      OpacityEffect opacityEffect_15x =OpacityEffect.fadeOut(EffectController(duration: 1.5));
      magnification_15x.add(opacityEffect_15x);
      magnification_15x.add(moveEffect_15x);
    });

    super.onLoad();
  }

}
