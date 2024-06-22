import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/sprite_number_component/sprite_number_component.dart';
import 'package:fortune_game/component/system_alert/big_win_line_hint.dart';
import 'package:fortune_game/component/system_alert/confirm_button.dart';


class BigMegaSuperWin extends PositionComponent with TapCallbacks{

  String startNumber;
  String endNumber;
  int showCount;

  BigMegaSuperWin({required this.startNumber, required this.endNumber, required this.showCount}) : super(anchor: Anchor.center, priority: 2);

  late ScaleEffect scaleEffect;
  late SpriteComponent spriteComponent;

  @override
  void onLoad() async {
    //灰色背景
    add(RectangleComponent(size: Vector2(1600, 1600), anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5)));

    scaleEffect = ScaleEffect.to(Vector2(1.2,1.2),EffectController(duration: 6));
    add(scaleEffect);

    spriteComponent = SpriteComponent(
      sprite: await Sprite.load('win_hint/big_win.png'),
      anchor: Anchor.bottomCenter,
    );
    add(spriteComponent);


    // await Future.delayed(Duration(seconds: 3));
    // if(totalWinAmount >= bettingAmountInt*5){
    //   if(totalWinAmount >= bettingAmountInt*15-1){
    //     BigWin bigWin = BigWin(startNumber: bettingAmount, endNumber:(bettingAmountInt*15-1).toString());
    //     add(bigWin);
    //   }else{
    //     BigWin bigWin = BigWin(startNumber: bettingAmount, endNumber: totalWinAmount.toString());
    //     add(bigWin);
    //   }
    // }
    // await Future.delayed(Duration(seconds: 3));
    // if(totalWinAmount >= bettingAmountInt*15){
    //   if(totalWinAmount > bettingAmountInt*30-1){
    //     MegaWin megaWin = MegaWin(startNumber: (bettingAmountInt*15).toString(), endNumber: (bettingAmountInt*30 -1).toString());
    //     add(megaWin);
    //   }else{
    //     MegaWin megaWin = MegaWin(startNumber: (bettingAmountInt*15).toString(), endNumber: (bettingAmountInt*30 -1).toString());
    //     add(megaWin);
    //   }
    // }
    // await Future.delayed(Duration(seconds: 3));
    // if(totalWinAmount >= bettingAmountInt*30){
    //   SuperWin superWin = SuperWin(startNumber: (bettingAmountInt*30).toString(), endNumber: totalWinAmount.toString());
    //   add(superWin);
    // }



    if(showCount == 2){
      Future.delayed(const Duration(seconds: 3), () async {
        remove(spriteComponent);
        spriteComponent = SpriteComponent(
          sprite: await Sprite.load('win_hint/mega_win.png'),
          anchor: Anchor.bottomCenter,
        );
        add(spriteComponent);
      });
    }else{
      Future.delayed(const Duration(seconds: 3), () async {
        remove(spriteComponent);
        spriteComponent = SpriteComponent(
          sprite: await Sprite.load('win_hint/mega_win.png'),
          anchor: Anchor.bottomCenter,
        );
        add(spriteComponent);
        Future.delayed(const Duration(seconds: 3), () async {
          remove(spriteComponent);
          spriteComponent = SpriteComponent(
            sprite: await Sprite.load('win_hint/super_win.png'),
            anchor: Anchor.bottomCenter,
          );
          add(spriteComponent);
          Future.delayed(const Duration(seconds: 3), () async {
            removeFromParent();
          });
        });

      });
    }








    add(BigWinLineHint(startNumber: startNumber, endNumber: endNumber));



    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
