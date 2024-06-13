import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:fortune_game/symbol/enum.dart';


class SlotMachineRollerBlock extends SpriteComponent {
  String image;
  BlockType blockType;
  int rollerIndex;

  SlotMachineRollerBlock({
    required this.image,
    required this.blockType,
    required this.rollerIndex,
    super.anchor,
    super.position,
    super.size,
  });

  MoveEffect? moveEffect;

  @override
  void onLoad() async {
    //Set sprite on load.
    sprite = await Sprite.load(image);

    //特殊方块需要比较大尺寸
    size = Vector2(125,93);
    priority = 1;
    if(image == 'blocks/symbol_wild.png'){
      size = Vector2(140,110);
      if(rollerIndex >= 2){
        priority = 2;
        size = Vector2(140,100);
      }
    }

    super.onLoad();
  }

}
