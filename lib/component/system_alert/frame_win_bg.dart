
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/sprite_number_component/sprite_number_component.dart';


class FrameWinBg extends SpriteComponent with TapCallbacks{
  final String score;
  final String bettingOdds;
  final bool needAnimation;

  FrameWinBg({required this.score,required this.bettingOdds,required this.needAnimation}) : super(anchor: Anchor.center,position: Vector2(-60,55));

  late TextComponent contentTextComponent;

  late ScaleEffect scaleEffect;
  late OpacityEffect opacityEffect;
  late OpacityProvider opacityProvider;
  @override
  void onLoad() async {
    sprite = await Sprite.load('win_hint/frame_win_bg.png');
    //缩放效果
    scaleEffect = ScaleEffect.by(
      Vector2.all(1.2),
      EffectController(duration: 0.3),
    );
    if(needAnimation){
      add(scaleEffect);
    }else{
      scale = Vector2.all(1.2);
    }
    add(SpriteNumberComponent(
      srcDirPath: 'image_numbers/total_score_numbers',
      anchor: Anchor.center,
      position: Vector2(150,55),
      initNum: int.parse(score),
    ));

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
