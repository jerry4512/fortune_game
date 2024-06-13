import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

typedef OnTap = void Function();

class ExButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;


  ExButton({required this.onTap}) : super(anchor: Anchor.bottomCenter, position: Vector2(-240, -175), size: Vector2(65,50), priority: 2);


  EffectController? effectController ;
  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/ex_button.png');
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }


  @override
  void update(double dt) {

  }

}
