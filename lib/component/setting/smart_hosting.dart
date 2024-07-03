import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/slot_machine/slot_machine.dart';
import 'package:fortune_game/symbol/parameter.dart';

typedef OnTap = void Function();

class SmartHosting extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  SmartHosting({required this.onTap}) :super( position: Vector2(0,-255));

  @override
  void onLoad() async {
    sprite = await Sprite.load('setting/smart_hosting.png');
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
