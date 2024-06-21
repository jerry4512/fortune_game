import 'dart:math';

import 'package:flame/components.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/parameter.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

class SlotMachineMagnificationRoller extends PositionComponent with HasGameRef {

  List<SlotMachineRollerBlock> blocksRoller;
  List<Vector2> blocksPositions;

  SlotMachineMagnificationRoller({super.position, required this.blocksRoller, required this.blocksPositions}) : super();

  List<Component> components = [];

  List<SlotMachineRollerBlock> newBlocks = [];
  List<SlotMachineRollerBlock> defaultBlocks = [];


  @override
  void onLoad() async {
    for(int i = 0 ; i < blocksRoller.length; i++){
      components.add(blocksRoller[i]);
    }
    addAll(components);

    //遮罩
    // add(ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(270,-95), size: Vector2(120, 290), children: components));
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

  void refreshBlocks(){
    removeAll(components);
    blocksRoller = [];
    newBlocks = [];
    components = [];
    addBlocks(newBlocks,BlockType.magnification);
    for(int i = 0 ; i < newBlocks.length; i++){
      components.add(newBlocks[i]);
    }
    blocksRoller = newBlocks;
    addAll(components);
  }

  //添加方块
  void addBlocks(List<SlotMachineRollerBlock> blocks,BlockType type){
    List<String> defaultBlocksImageList = SymbolBlocks().blocksImageList;
    //开启Ex模式时移除1倍方块
    List<Vector2> positions = blocksPositions;
    BlockType blockType = BlockType.block;
    if(type == BlockType.magnification){
      defaultBlocksImageList = SymbolBlocks().magnificationImageList;
      if(Parameter.isOpenExMode){
        defaultBlocksImageList.removeAt(0);
      }
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

  void changeExMode(){
    removeAll(components);
    for(int i = 0 ; i < blocksRoller.length; i++){
      print( blocksRoller[i].image);
    }
    defaultBlocks = blocksRoller;
    blocksRoller = [];
    newBlocks = [];
    components = [];

    List<String>  defaultBlocksImageList = SymbolBlocks().magnificationImageList;
    //移除1倍方块
    defaultBlocksImageList.removeAt(0);

    Random random = Random();
    for (int i = 0; i < 5; i++) {
      // 随机选择一个索引
      int index = random.nextInt(defaultBlocksImageList.length);
      // 获取这个索引对应的图片并添加到列表中
      if(i <= 1){
        var block = SlotMachineRollerBlock(
          image: defaultBlocksImageList[index],
          anchor: Anchor.topCenter,
          position: SymbolBlocks().magnificationPositions[i],
          blockType: BlockType.magnification,
          rollerIndex: i,
        );
        newBlocks.add(block);
      }else if(i == 2){
        var block = SlotMachineRollerBlock(
          image: 'magnifications/magnification_10x.png',
          anchor: Anchor.topCenter,
          position: SymbolBlocks().magnificationPositions[i],
          blockType: BlockType.magnification,
          rollerIndex: i,
        );
        newBlocks.add(block);
      }else if(i == 3){
        var block = SlotMachineRollerBlock(
          image:  'magnifications/magnification_15x.png',
          anchor: Anchor.topCenter,
          position: SymbolBlocks().magnificationPositions[i],
          blockType: BlockType.magnification,
          rollerIndex: i,
        );
        newBlocks.add(block);
      }else{
        var block = SlotMachineRollerBlock(
          image:  'magnifications/magnification_5x.png',
          anchor: Anchor.topCenter,
          position: SymbolBlocks().magnificationPositions[i],
          blockType: BlockType.magnification,
          rollerIndex: i,
        );
        newBlocks.add(block);
      }

    }
    for(int i = 0 ; i < newBlocks.length; i++){
      components.add(newBlocks[i]);
    }
    blocksRoller = newBlocks;
    addAll(components);
  }

  void revertRoller(){
    if(defaultBlocks.isNotEmpty){
      removeAll(components);
      blocksRoller = defaultBlocks;
      components = [];
      for(int i = 0 ; i < defaultBlocks.length; i++){
        defaultBlocks[i].removeMask();
        components.add(defaultBlocks[i]);
      }
      addAll(components);
    }
  }

}