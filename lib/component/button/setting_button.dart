import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

typedef OnTap = void Function();

class SettingButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;
  SettingButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(-270,210), size: Vector2(50,50));

  late SpriteComponent menuSpriteComponent;
  bool isMenuOpen = false;

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/icon_setting.png');

    menuSpriteComponent = SpriteComponent(
      sprite: await Sprite.load('setting_menu.png'),
      size: Vector2(50,150),
      position: Vector2(25,-150),
      anchor: Anchor.topCenter,
    );

    if(isMenuOpen){
      add(menuSpriteComponent);
    }else{
      if(menuSpriteComponent.isMounted){
        remove(menuSpriteComponent);
      }
    }

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    isMenuOpen = !isMenuOpen;
    if(isMenuOpen){
      add(menuSpriteComponent);
    }else{
      if(menuSpriteComponent.isMounted){
        remove(menuSpriteComponent);
      }
    }

  }


  @override
  void update(double dt) {

  }

}
