
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

class SlotMachineBlocksRoller extends PositionComponent{
  List<SlotMachineRollerBlock> blocksRoller;
  List<Vector2> blocksPositions;

  SlotMachineBlocksRoller({super.position,required this.blocksRoller,required this.blocksPositions}) : super(anchor: Anchor.topCenter);

  List<Component> components = [];

  List<SlotMachineRollerBlock> newBlocks = [];

  late RectangleComponent rectangleComponent;

  @override
  void onLoad() async {
    for(int i = 0 ; i < blocksRoller.length; i++){
      components.add(blocksRoller[i]);
    }
    addAll(components);
    //遮罩
    //
    // rectangleComponent = RectangleComponent(position: position, size: Vector2(1370, 970), anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5),priority: 2);
    // add(rectangleComponent);
    // add(ClipComponent.rectangle(anchor: Anchor.topCenter,position: Vector2(-200,-95), size: Vector2(143, 290), children: components));
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }

  //重新生成方块，未来可接API最后资料
  void refreshBlocks(){
    removeAll(components);
    blocksRoller = [];
    newBlocks = [];
    components = [];
    addBlocks(newBlocks,BlockType.block);
    for(int i = 0 ; i < newBlocks.length; i++){
      components.add(newBlocks[i]);
    }
    blocksRoller = newBlocks;
    addAll(components);
  }

  //添加方块
  void addBlocks(List<SlotMachineRollerBlock> blocks,BlockType type){
    List<String> defaultBlocksImageList = SymbolBlocks().blocksImageList;
    List<Vector2> positions = blocksPositions;
    BlockType blockType = BlockType.block;
    if(type == BlockType.magnification){
      defaultBlocksImageList = SymbolBlocks().magnificationImageList;
      positions = SymbolBlocks().magnificationPositions;
      blockType = BlockType.magnification;
    }
    // 创建Random对象用于生成随机数
    Random random = Random();
    for (int i = 0; i < 5; i++) {
      // 随机选择一个索引
      int index = random.nextInt(defaultBlocksImageList.length);
      // 获取这个索引对应的图片并添加到列表中
      var block = SlotMachineRollerBlock(
        image: defaultBlocksImageList[index],
        anchor: Anchor.topCenter,
        position: positions[i],
        blockType: blockType,
        rollerIndex: i,
      );
      blocks.add(block);
    }
  }

}