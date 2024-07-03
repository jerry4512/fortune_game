import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:fortune_game/component/bet_option/bet_number.dart';

typedef OnTap = void Function(String);

class BetButton extends SpriteComponent with TapCallbacks{
  final OnTap onTap;
  BetButton({required this.onTap}) : super(anchor: Anchor.topCenter, position: Vector2(-130,280),size: Vector2(50,50),priority: 2);

  late SpriteComponent spriteComponent;

  List<Component> components = [];

  bool isPressed = false;

  String betNumber = '3';

  late TextComponent textComponent;

  @override
  void onLoad() async {
    sprite = await Sprite.load('buttons/icon_bet.png');
    init();

    textComponent = TextComponent(
      text: 'Bet $betNumber',
      position: Vector2(-1, 50),
      size: Vector2(50, 20),
      scale: Vector2(0.9,0.9),
    );

    add(textComponent);

    super.onLoad();
  }

  Future<void> init() async {
    spriteComponent = SpriteComponent(
        sprite: await Sprite.load('bet_options_frame_l.png'),
    anchor: Anchor.bottomCenter,
    scale: Vector2(0.45,0.45),
    position: Vector2(25,-10)
    );
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '1000', numberPosition: Vector2(-65, -275)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '200', numberPosition: Vector2(25, -275)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '8', numberPosition: Vector2(112, -275)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '700', numberPosition: Vector2(-65, -220)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '100', numberPosition: Vector2(25, -220)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '5', numberPosition: Vector2(112, -220)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '500', numberPosition: Vector2(-65, -165)));
    components.add((BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '50', numberPosition: Vector2(25, -165))));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '3', numberPosition: Vector2(112, -165)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '400', numberPosition: Vector2(-65, -110)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '20', numberPosition: Vector2(25, -110)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '2', numberPosition: Vector2(112, -110)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '300', numberPosition: Vector2(-65, -55)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '10', numberPosition: Vector2(25, -55)));
    components.add(BetNumber(onTap:(number){
      betNumberOnTap(number);
    }, number: '1', numberPosition: Vector2(112, -55)));
  }

  void betNumberOnTap(String number){
    betNumber = number;
    remove(textComponent);
    textComponent = TextComponent(
      text: 'Bet $betNumber',
      position: Vector2(-1, 50),
      size: Vector2(50, 20),
      scale: Vector2(0.9,0.9),
    );
    add(textComponent);
    remove(spriteComponent);
    removeAll(components);
    onTap(betNumber);
  }

  @override
  void onTapDown(TapDownEvent event) {

    isPressed = !isPressed;
    if(isPressed){
      add(spriteComponent);
      addAll(components);
    }else{
      remove(spriteComponent);
      removeAll(components);
    }

  }


  @override
  void update(double dt) {

  }

}
