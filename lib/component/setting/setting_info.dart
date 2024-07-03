import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/slot_machine/slot_machine.dart';
import 'package:fortune_game/symbol/parameter.dart';

typedef OnTap = void Function();

class SettingInfo extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  SettingInfo({required this.onTap}) :super( position: Vector2(0,-135));

  @override
  void onLoad() async {
    sprite = await Sprite.load('setting/setting_info.png');
    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    onTap();

  }


  @override
  void update(double dt) {

  }

}
