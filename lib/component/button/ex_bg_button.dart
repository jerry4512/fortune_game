import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/button/ex_question.dart';
import 'package:fortune_game/component/button/ex_switch_button.dart';
import 'package:fortune_game/component/system_alert/system_explanation.dart';

typedef OnTap = void Function(Map);

class ExBgButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  ExBgButton({required this.onTap}) : super(position: Vector2(-180,5), size: Vector2(230, 50));

  late SpriteComponent switchSprite;
  late SpriteComponent exQuestionSprite;
  Map<String, bool> resultMap = {
    'switchSprite': false,
    'exQuestionSprite': false,
  };

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
      resultMap['switchSprite'] = value;
      onTap(resultMap);
    });

    exQuestionSprite = ExQuestion(onTap: (value){
      resultMap['exQuestionSprite'] = value;
      onTap(resultMap);
    });

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
