import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';


class WinMagnificationBlock extends SpriteComponent {
  String image;

  WinMagnificationBlock({required this.image}) : super(size: Vector2(125,93), position: Vector2(147,8));


  MoveEffect? moveEffect;

  late RectangleComponent rectangleComponent;

  @override
  void onLoad() async {
    sprite = await Sprite.load(image);


    Future.delayed(const Duration(seconds: 1), () {
      add(OpacityEffect.fadeOut(
        EffectController(duration: 0.7),
      ));
    });


    super.onLoad();
  }

  Future<void> addMask() async {
    await add(rectangleComponent);

  }

  void removeMask(){
    Future.delayed(const Duration(milliseconds: 50), () {
      remove(rectangleComponent);
    });
  }

}
