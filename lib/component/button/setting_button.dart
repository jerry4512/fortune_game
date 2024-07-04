import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/setting/setting_info.dart';
import 'package:fortune_game/component/setting/setting_record.dart';
import 'package:fortune_game/component/setting/setting_sound.dart';
import 'package:fortune_game/component/setting/smart_hosting.dart';
import 'package:fortune_game/symbol/parameter.dart';

typedef OnTap = void Function();

class SettingButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;
  SettingButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(-270,280), size: Vector2(50,50));

  late SpriteComponent menuSpriteComponent;
  bool isMenuOpen = false;
  List<Component> components = [];

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/icon_setting.png');
    priority = 2;

    menuSpriteComponent = SpriteComponent(
      sprite: await Sprite.load('setting/setting_background.png'),
      position: Vector2(25,-270),
      anchor: Anchor.topCenter,
    );

    if(isMenuOpen){
      add(menuSpriteComponent);
    }else{
      if(menuSpriteComponent.isMounted){
        remove(menuSpriteComponent);
      }
    }

    components.add(SmartHosting(onTap: (){
      closeMenu();
    }));
    components.add(SettingRecord(onTap: (){
      closeMenu();
    }));
    components.add(SettingInfo(onTap: (){
      closeMenu();
    }));
    components.add(SettingSound(onTap: (){
      Parameter.isSoundOn = !Parameter.isSoundOn;
      closeMenu();
    }));

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    isMenuOpen = !isMenuOpen;
    if(isMenuOpen){
      add(menuSpriteComponent);
      addAll(components);
    }else{
      if(menuSpriteComponent.isMounted){
        remove(menuSpriteComponent);
        removeAll(components);
      }
    }
  }

  void closeMenu(){
    isMenuOpen = !isMenuOpen;
    remove(menuSpriteComponent);
    removeAll(components);
  }


  @override
  void update(double dt) {

  }

}
