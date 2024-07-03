
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/models/game_response_model.dart';
import 'package:fortune_game/symbol/demo_json.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/parameter.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

class SlotMachineBlocksRoller extends PositionComponent{
  List<SlotMachineRollerBlock> blocksRoller;
  List<Vector2> blocksPositions;

  SlotMachineBlocksRoller({super.position,required this.blocksRoller,required this.blocksPositions}) : super(anchor: Anchor.topCenter);

  List<Component> components = [];

  List<SlotMachineRollerBlock> newBlocks = [];

  late RectangleComponent rectangleComponent;

  List<SlotMachineRollerBlock> defaultBlocks = [];


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

  //最后结果
  void getLastResultBlocks(int count,RollerType rollerType){
    List demoJsonList = DemoJson().demoJsonList;
    // bool useListIndexOne = determineEven(count);
    GameResponse gameResponse;
    gameResponse = GameResponse.fromJson(demoJsonList[Parameter.jsonCount % demoJsonList.length]);
    // if(useListIndexOne){
    //   gameResponse = GameResponse.fromJson(demoJsonList[0]);
    // }else{
    //   gameResponse = GameResponse.fromJson(demoJsonList[1]);
    // }
    removeAll(components);
    blocksRoller = [];
    newBlocks = [];
    components = [];
    List<String> defaultBlocksImageList = SymbolBlocks().blocksImageList;
    List<Vector2> positions = blocksPositions;
    BlockType blockType = BlockType.block;
    List<String> panel  = gameResponse.resultMap.detail[0].panel;
    print(panel);
    Random random = Random();
    int index = random.nextInt(defaultBlocksImageList.length);
    int panelFirstIndex = 0;
    int panelSecondIndex = 1;
    int panelThirdIndex = 2;
    if(rollerType == RollerType.firstRoller){
      //第一行
      for (int i = 0; i < 5; i++) {
        if(i>=2){
          var block = SlotMachineRollerBlock(
            image: imagePath(defaultBlocksImageList,panel[panelFirstIndex]),
            anchor: Anchor.topCenter,
            position: positions[i],
            blockType: blockType,
            rollerIndex: i,
          );
          newBlocks.add(block);
          panelFirstIndex = panelFirstIndex+3;
        }else{
          //隐藏的两个方块（随机）
          var block = SlotMachineRollerBlock(
            image: defaultBlocksImageList[index],
            anchor: Anchor.topCenter,
            position: positions[i],
            blockType: blockType,
            rollerIndex: i,
          );
          newBlocks.add(block);
        }
      }
    }else if(rollerType == RollerType.secondRoller){
      //第二行
      for (int i = 0; i < 5; i++) {
        if(i>=2){
          var block = SlotMachineRollerBlock(
            image: imagePath(defaultBlocksImageList,panel[panelSecondIndex]),
            anchor: Anchor.topCenter,
            position: positions[i],
            blockType: blockType,
            rollerIndex: i,
          );
          newBlocks.add(block);
          panelSecondIndex = panelSecondIndex+3;
        }else{
          //隐藏的两个方块（随机）
          var block = SlotMachineRollerBlock(
            image: defaultBlocksImageList[index],
            anchor: Anchor.topCenter,
            position: positions[i],
            blockType: blockType,
            rollerIndex: i,
          );
          newBlocks.add(block);
        }
      }
    }else{
      //第三行
      for (int i = 0; i < 5; i++) {
        if(i>=2){
          var block = SlotMachineRollerBlock(
            image: imagePath(defaultBlocksImageList,panel[panelThirdIndex]),
            anchor: Anchor.topCenter,
            position: positions[i],
            blockType: blockType,
            rollerIndex: i,
          );
          newBlocks.add(block);
          panelThirdIndex = panelThirdIndex+3;
        }else{
          //隐藏的两个方块（随机）
          var block = SlotMachineRollerBlock(
            image: defaultBlocksImageList[index],
            anchor: Anchor.topCenter,
            position: positions[i],
            blockType: blockType,
            rollerIndex: i,
          );
          newBlocks.add(block);
        }
      }
    }
    for(int i = 0 ; i < newBlocks.length; i++){
      components.add(newBlocks[i]);
    }
    blocksRoller = newBlocks;
    addAll(components);
  }

  String imagePath(List<String> defaultBlocksImageList, String response){
    String result = '';
    for(int i =0;i<defaultBlocksImageList.length;i++){
      if(defaultBlocksImageList[i].contains(response.toLowerCase())){
        result =defaultBlocksImageList[i];
        break;
      }
    }
    return result;
  }

  //判断是否为偶数（单纯测试区分两次结果）
  bool determineEven(int number) {
    if (number % 2 == 0) {
      return true; // Even
    } else {
      return false; // Odd
    }
  }

  //重新生成方块，未来可接API最后资料
  void refreshBlocks(){
    removeAll(components);
    blocksRoller = [];
    newBlocks = [];
    components = [];
    addBlocks(newBlocks,BlockType.block);
    // newBlocks = [
    //   SlotMachineRollerBlock(
    //     image: 'blocks/symbol_wild.png',
    //     anchor: Anchor.topCenter,
    //     position: blocksPositions[0],
    //     blockType: BlockType.block,
    //     rollerIndex: 0,
    //   ),
    //   SlotMachineRollerBlock(
    //     image: 'blocks/symbol_wild.png',
    //     anchor: Anchor.topCenter,
    //     position: blocksPositions[1],
    //     blockType: BlockType.block,
    //     rollerIndex: 1,
    //   ),
    //   SlotMachineRollerBlock(
    //     image: 'blocks/symbol_wild.png',
    //     anchor: Anchor.topCenter,
    //     position: blocksPositions[2],
    //     blockType: BlockType.block,
    //     rollerIndex: 2,
    //   ),
    //   SlotMachineRollerBlock(
    //     image: 'blocks/symbol_wild.png',
    //     anchor: Anchor.topCenter,
    //     position: blocksPositions[3],
    //     blockType: BlockType.block,
    //     rollerIndex: 3,
    //   ),
    //   SlotMachineRollerBlock(
    //     image: 'blocks/symbol_wild.png',
    //     anchor: Anchor.topCenter,
    //     position: blocksPositions[4],
    //     blockType: BlockType.block,
    //     rollerIndex: 4,
    //   ),
    // ];
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

  void changeExMode(int indexRoller){
    for(int i = 0 ; i < components.length; i++){
      SlotMachineRollerBlock? block = components[i] as SlotMachineRollerBlock?;
      block!.removeMask();
    }
    removeAll(components);
    defaultBlocks = blocksRoller;
    blocksRoller = [];
    newBlocks = [];
    components = [];

    for (int i = 0; i < 5; i++) {
      if(indexRoller == 0){
        var block = SlotMachineRollerBlock(
          image: 'blocks/symbol_wild.png',
          anchor: Anchor.topCenter,
          position: SymbolBlocks().blocksPositions[i],
          blockType: BlockType.block,
          rollerIndex: i,
        );
        newBlocks.add(block);
      }else if(indexRoller == 1){
        var block = SlotMachineRollerBlock(
          image: 'blocks/symbol_h1.png',
          anchor: Anchor.topCenter,
          position: SymbolBlocks().blocksPositions[i],
          blockType: BlockType.block,
          rollerIndex: i,
        );
        newBlocks.add(block);
      }else{
        var block = SlotMachineRollerBlock(
          image: 'blocks/symbol_h2.png',
          anchor: Anchor.topCenter,
          position: SymbolBlocks().blocksPositions[i],
          blockType: BlockType.block,
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