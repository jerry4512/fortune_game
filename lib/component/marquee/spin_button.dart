import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

typedef OnTap = void Function();

class MarqueeText extends PositionComponent with TapCallbacks{

  final OnTap onTap;
  MarqueeText({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(135, -170), size: Vector2(800,60));

  late EffectController effectController;
  late MoveEffect moveEffect;
  late SpriteComponent spriteComponent;
  late String marqueeText;
  late ClipComponent clipComponent;

  List<Component> components = [];



  @override
  void onLoad() async {
    getMarqueeText();
    spriteComponent = SpriteComponent(sprite: await Sprite.load( 'marquees/marquee_text_1.png'));
    effectController = RepeatedEffectController(LinearEffectController(15), 5);

    // effectController = EffectController(duration: 10);

    moveEffect = MoveEffect.to(Vector2(spriteComponent.position.x -1400, spriteComponent.position.y),
        effectController);

    // moveEffect = MoveEffect.to(Vector2(spriteComponent.position.x -500, spriteComponent.position.y),
    //     effectController);
    spriteComponent.add(moveEffect);


    components.add(spriteComponent);
    clipComponent = ClipComponent.rectangle(anchor: Anchor.topCenter,position: Vector2(200,10), size: Vector2(400, 290), children: components);
    add(clipComponent);

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }


  @override
  void update(double dt) {
    // if(effectController.completed){
    //   changeMarqueeText();
    // }
  }

  Future<void> changeMarqueeText() async {
    components = [];
    moveEffect.reset();
    getMarqueeText();
    spriteComponent.removeAll(spriteComponent.children.whereType<Effect>());
    remove(clipComponent);

    spriteComponent = SpriteComponent(sprite: await Sprite.load(marqueeText),position: Vector2(0,0));
    spriteComponent.add(moveEffect);

    components.add(spriteComponent);
    clipComponent = ClipComponent.rectangle(anchor: Anchor.topCenter,position: Vector2(200,10), size: Vector2(400, 290), children: components);
    add(clipComponent);

    // effectController = EffectController(duration: 10);
    // moveEffect = MoveEffect.to(Vector2(spriteComponent.position.x -1400, spriteComponent.position.y),
    //     effectController);
    // spriteComponent.add(moveEffect);

  }

  void getMarqueeText(){
    Random random = Random();
    List<String> defaultMarqueeTextList = SymbolBlocks().marqueeText;
    int index = random.nextInt(defaultMarqueeTextList.length);
    marqueeText = defaultMarqueeTextList[index];

  }

}
