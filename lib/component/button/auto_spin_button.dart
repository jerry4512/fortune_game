import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/slot_machine/slot_machine.dart';
import 'package:fortune_game/symbol/parameter.dart';

typedef OnTap = void Function();

class AutoSpinButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  AutoSpinButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(100,280), size: Vector2(50,50));

  EffectController? effectController ;
  @override
  void onLoad() async {
    if(Parameter.isQuickMode){
      sprite = await Sprite.load('buttons/icon_stop_auto_spin_button.png');
    }else{
      sprite = await Sprite.load('buttons/icon_auto_spin_button.png');
    }

    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    onTap();
    Parameter.isQuickMode = !Parameter.isQuickMode;
    if(Parameter.isQuickMode){
      sprite = await Sprite.load('buttons/icon_stop_auto_spin_button.png');
    }else{
      sprite = await Sprite.load('buttons/icon_auto_spin_button.png');
    }
  }


  @override
  void update(double dt) {

  }

}
