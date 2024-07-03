import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/slot_machine/slot_machine.dart';
import 'package:fortune_game/symbol/parameter.dart';

typedef OnTap = void Function();

class SettingSound extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  SettingSound({required this.onTap}) :super( position: Vector2(3,-75));

  @override
  void onLoad() async {
    sprite = await Sprite.load((Parameter.isSoundOn)?'setting/setting_sound_on.png':'setting/setting_sound_off.png');
    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    onTap();

  }


  @override
  Future<void> update(double dt) async {
    sprite = await Sprite.load((Parameter.isSoundOn)?'setting/setting_sound_on.png':'setting/setting_sound_off.png');
  }

}
