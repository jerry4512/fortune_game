import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/component/system_alert/confirm_button.dart';

typedef OnTap = void Function();

class SystemAlert extends SpriteComponent with TapCallbacks{
  final OnTap onTap;

  SystemAlert({required this.onTap}) : super(anchor: Anchor.center);

  late SpriteComponent confirmButton;

  late TextComponent title;
  late TextComponent content;



  EffectController? effectController ;
  @override
  void onLoad() async {
    sprite = await Sprite.load('system_popup_bg.png');
    position = Vector2(0, -200);
    size = Vector2(500, 350);


    title = TextComponent(
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style : const TextStyle(
          fontSize: 24,
          color: Color.fromRGBO(237, 168, 43, 1)
        )
      ),
      position: Vector2(250,47),
      text: 'System Alert',
    );
    add(title);

    content = TextComponent(
      anchor: Anchor.center,
      textRenderer: TextPaint(
          style : const TextStyle(
              fontSize: 20,
              color: Colors.white
          )
      ),
      position: Vector2(250,177),
      text: 'Your balance is insufficient',
    );

    add(content);

    confirmButton=ConfirmButton(onTap: (){
      onTap();
    });

    add(confirmButton);
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

  }


  @override
  void update(double dt) {

  }

}
