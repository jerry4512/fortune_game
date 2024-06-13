import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/button/ex_switch_button.dart';

typedef OnTap = void Function(bool);

class ExBgButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  ExBgButton({required this.onTap}) : super(position: Vector2(-180,5), size: Vector2(230, 50));

  late SpriteComponent switchSprite;
  late SpriteComponent exQuestionSprite;

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/ex_bg.png');

    //文字
    add(TextComponent(
      text: 'Extra Bet',
      scale: Vector2(0.8, 0.8),
      position: Vector2(35, 10),
    ));

    //开关
    switchSprite = ExSwitchButton(onTap: (value){
      onTap(value);
    });

    exQuestionSprite = SpriteComponent(
        sprite: await Sprite.load('buttons/ex_question_mark.png'),
        scale: Vector2(0.8,0.8),
        position: Vector2(210, 7)
    );

    add(switchSprite);
    add(exQuestionSprite);

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
  }


  @override
  void update(double dt) {

  }

}
