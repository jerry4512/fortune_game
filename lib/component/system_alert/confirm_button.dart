import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

typedef OnTap = void Function();

class ConfirmButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  ConfirmButton({required this.onTap}) : super(anchor: Anchor.topLeft);

  late TextComponent textComponent;

  @override
  void onLoad() async {
    sprite = await Sprite.load('confirm_btn_bg.png');
    position = Vector2(155, 270);
    size = Vector2(200, 70);

    textComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(100,37),
      text: 'Confirm',
    );
    add(textComponent);

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
