
import 'package:flame/components.dart';
import 'package:flame/events.dart';

typedef OnTap = void Function(bool);

class ExSwitchButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  ExSwitchButton({required this.onTap}) : super( scale: Vector2(0.7,0.7), position: Vector2(130, 5));

  bool isOn = false;

  @override
  void onLoad() async {
    if(isOn){
      sprite = await Sprite.load('buttons/ex_on.png');
    }else{
      sprite = await Sprite.load('buttons/ex_off.png');
    }

    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    isOn = !isOn;
    if(isOn){
      sprite = await Sprite.load('buttons/ex_on.png');
      onTap(true);
    }else{
      sprite = await Sprite.load('buttons/ex_off.png');
      onTap(false);
    }
  }


  @override
  void update(double dt) {

  }

}
