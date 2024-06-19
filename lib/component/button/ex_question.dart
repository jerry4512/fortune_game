import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/bet_option/bet_number.dart';
import 'package:fortune_game/component/system_alert/system_explanation.dart';

typedef OnTap = void Function(bool);

class ExQuestion extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  ExQuestion({required this.onTap}) : super( scale: Vector2(0.8,0.8), position: Vector2(210, 7));
  bool isOpen = false;


  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/ex_question_mark.png');

    super.onLoad();
  }


  @override
  void onTapDown(TapDownEvent event) {
    isOpen = !isOpen;
    onTap(isOpen);
  }

}
