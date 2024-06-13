import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

typedef OnTap = void Function();

class QuickStartButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;


  QuickStartButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(170,280), size: Vector2(50,50));


  bool isOn = false;

  late Sprite spriteImage;

  EffectController? effectController ;
  @override
  void onLoad() async {
    if(isOn){
      sprite = await Sprite.load('buttons/icon_quick_start_turn_off.png');
    }else{
      sprite = await Sprite.load('buttons/icon_quick_start_turn_on.png');
    }

    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    onTap();
    isOn = !isOn;
    if(isOn){
      sprite = await Sprite.load('buttons/icon_quick_start_turn_off.png');
    }else{
      sprite = await Sprite.load('buttons/icon_quick_start_turn_on.png');
    }
  }


  @override
  void update(double dt) {

  }

}
