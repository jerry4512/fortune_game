
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/sprite_number_component/sprite_number_component.dart';


class BigWinLineHint extends SpriteComponent with TapCallbacks{

  String startNumber;
  String endNumber;
  //Win 數字，拿來跳動倒數
  SpriteNumberComponent? _winNumber;

  BigWinLineHint({required this.startNumber, required this.endNumber}) : super(anchor: Anchor.center, position: Vector2(0, 0),scale: Vector2(0.6,0.6));

  @override
  void onLoad() async {
    sprite = await Sprite.load('/win_hint/big_win_line_hint.png');

    await init();
    add(_winNumber!);
    // add(TextComponent(
    //     textRenderer: TextPaint(
    //         style : const TextStyle(
    //             fontSize: 100,
    //             // fontSize: 200,
    //             color: Color.fromRGBO(237, 168, 43, 1)
    //         )
    //     ),
    //     text: score,
    //     anchor: Anchor.center,
    //     position: Vector2(560,255),
    //     priority: 2
    // ));
    Future.delayed(const Duration(milliseconds: 500), () {
      _winNumber?.tickTo(int.parse(endNumber),duration: const Duration(milliseconds: 8500));
    });



    super.onLoad();
  }

  init(){
    _winNumber = SpriteNumberComponent(
      srcDirPath: 'image_numbers/banner_numbers',
      anchor: Anchor.center,
      position: Vector2((size.x / 2),250),
      initNum: int.parse(startNumber),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
