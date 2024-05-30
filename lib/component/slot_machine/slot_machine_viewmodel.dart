import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:fortune_game/component/roller/slot_machine_blocks_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_magnification_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';


class SlotMachineViewModel{

  late EffectController slotMachineBlocksRollerFirstEffectController;
  late EffectController slotMachineBlocksRollerSecondEffectController;
  late EffectController slotMachineBlocksRollerThirdEffectController;
  late RepeatedEffectController slotMachineMagnificationRollerEffectController;

  late MoveEffect blockFirstMoveEffect;
  late MoveEffect blockSecondMoveEffect;
  late MoveEffect blockThirdMoveEffect;
  late MoveEffect blockMoveEffect;
  late MoveEffect magnificationMoveEffect;

  late SlotMachineBlocksRoller slotMachineBlocksFirstRoller;
  late SlotMachineBlocksRoller slotMachineBlocksSecondRoller;
  late SlotMachineBlocksRoller slotMachineBlocksThirdRoller;

  late SlotMachineMagnificationRoller slotMachineMagnificationRoller;

  List<SlotMachineRollerBlock> blocksRollerFirst = [];
  List<SlotMachineRollerBlock> blocksRollerSecond = [];
  List<SlotMachineRollerBlock> blocksRollerThird= [];

  List<SlotMachineRollerBlock> magnification = [];

  List<List<SlotMachineRollerBlock>> rollersList = [];
  List<SlotMachineBlocksRoller> slotMachineBlocksRollersList = [];
  List<EffectController> effectControllerList = [];
  List<EffectController> moveEffectList = [];

  //當前滾動狀態。
  RollerState rollerState = RollerState.stopped;

  List<Vector2> blocksPositions = [
    // //未来显示
    // Vector2(65,-187),
    // Vector2(65,-92),
    // //当前显示
    // Vector2(65,3),
    // Vector2(65,98),
    // Vector2(65,193),

    //未来显示
    Vector2(343,-100),
    Vector2(343,0),
    //当前显示
    Vector2(343,100),
    Vector2(343,200),
    Vector2(343,300),
  ];

  List<Vector2> magnificationPositions = [
    // //未来显示
    // Vector2(55,-196),
    // Vector2(55,-98),
    // //当前显示
    // Vector2(55,0),
    // Vector2(55,98),
    // Vector2(55,196),
    //未来显示
    Vector2(-136,-100),
    Vector2(-136,0),
    //当前显示
    Vector2(-136,100),
    Vector2(-136,200),
    Vector2(-136,300),
  ];

  //初始化
  void init(){
    //将三行的方块行放入同一个List，方便后续操作
    rollersList.add(blocksRollerFirst);
    rollersList.add(blocksRollerSecond);
    rollersList.add(blocksRollerThird);

    //初始化EffectControl
    slotMachineBlocksRollerFirstEffectController = RepeatedEffectController(LinearEffectController(0.1), 10);
    slotMachineBlocksRollerSecondEffectController = RepeatedEffectController(LinearEffectController(0.1), 10);
    slotMachineBlocksRollerThirdEffectController = RepeatedEffectController(LinearEffectController(0.1), 10);
    slotMachineMagnificationRollerEffectController = RepeatedEffectController(LinearEffectController(0.1), 10);

    //将方块行的EffectControl放上同一个List，方便后续操作
    effectControllerList.add(slotMachineBlocksRollerFirstEffectController);
    effectControllerList.add(slotMachineBlocksRollerSecondEffectController);
    effectControllerList.add(slotMachineBlocksRollerThirdEffectController);

    //方块行添加方块
    for(int i = 0;i < 3;i++){
      addBlocks(rollersList[i],BlockType.block);
    }

    //初始化方块行
    slotMachineBlocksFirstRoller = SlotMachineBlocksRoller(position: Vector2(-268, -96), blocksRoller: blocksRollerFirst, blocksPositions: blocksPositions);
    slotMachineBlocksSecondRoller = SlotMachineBlocksRoller(position: Vector2(-272, -96), blocksRoller: blocksRollerSecond, blocksPositions: blocksPositions);
    slotMachineBlocksThirdRoller = SlotMachineBlocksRoller(position: Vector2(-276, -96), blocksRoller: blocksRollerThird, blocksPositions: blocksPositions);

    //将方块行放上同一个List，方便后续操作
    slotMachineBlocksRollersList.add(slotMachineBlocksFirstRoller);
    slotMachineBlocksRollersList.add(slotMachineBlocksSecondRoller);
    slotMachineBlocksRollersList.add(slotMachineBlocksThirdRoller);

    //倍率行添加方块
    addBlocks(magnification, BlockType.magnification);
    //初始化倍率行
    slotMachineMagnificationRoller = SlotMachineMagnificationRoller(position: Vector2(200,-100), blocksRoller: magnification, blocksPositions: magnificationPositions);


  }

  //添加方块
  void addBlocks(List<Component> blocks,BlockType type){
    List<String> defaultBlocksImageList = SymbolBlocks().blocksImageList;
    List<Vector2> positions = blocksPositions;
    BlockType blockType = BlockType.block;
    if(type == BlockType.magnification){
      defaultBlocksImageList = SymbolBlocks().magnificationImageList;
      positions = magnificationPositions;
      blockType = BlockType.magnification;
    }

    // 创建Random对象用于生成随机数
    Random random = Random();
    // 循环3次，每次随机选择一个图片
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

  //开始转动
  void startSpinning(){
    // print(rollerState);
    if(rollerState == RollerState.stopped){
      rollerState = RollerState.rolling;


      //方块行
      for(int i = 0 ; i< slotMachineBlocksRollersList.length ; i++){
        SlotMachineBlocksRoller slotMachineBlocksRoller = slotMachineBlocksRollersList[i];
        blockMoveEffect = MoveEffect.to(Vector2(slotMachineBlocksRoller.position.x, slotMachineBlocksRoller.position.y + 200),
            effectControllerList[i],onComplete: (){
              // rollerState = RollerState.stopped;
              // blockMoveEffect!.reset();
              //
              // blocksRollerFirst.clear();
              // blocksRollerSecond.clear();
              // blocksRollerSecond.clear();
              // rollersList.clear();
              // rollersList.add(blocksRollerFirst);
              // rollersList.add(blocksRollerSecond);
              // rollersList.add(blocksRollerThird);
              //
              // slotMachineBlocksFirstRoller = SlotMachineBlocksRoller(position: Vector2(-268, -96), blocksRoller: blocksRollerFirst, blocksPositions: blocksPositions);
              // slotMachineBlocksSecondRoller = SlotMachineBlocksRoller(position: Vector2(-272, -96), blocksRoller: blocksRollerSecond, blocksPositions: blocksPositions);
              // slotMachineBlocksThirdRoller = SlotMachineBlocksRoller(position: Vector2(-276, -96), blocksRoller: blocksRollerThird, blocksPositions: blocksPositions);
            });
        slotMachineBlocksRoller.add(blockMoveEffect);
      }



      //倍率行
      // slotMachineMagnificationRollerEffectController = RepeatedEffectController(LinearEffectController(0.1), 10);
      // slotMachineMagnificationRoller.removeAll(slotMachineMagnificationRoller.children.whereType<Effect>());
      // magnificationMoveEffect = MoveEffect.to(Vector2(slotMachineMagnificationRoller.position.x, slotMachineMagnificationRoller.position.y + 200),
      //     slotMachineMagnificationRollerEffectController);
      // slotMachineMagnificationRoller.add(magnificationMoveEffect);
      // print(slotMachineMagnificationRoller);

      // 重新创建动画效果以确保能够重新启动
      // magnificationMoveEffect = MoveEffect.to(
      //     Vector2(slotMachineMagnificationRoller.position.x, slotMachineMagnificationRoller.position.y + 200),
      //     RepeatedEffectController(LinearEffectController(0.1), 10)  // 重新创建一个新的EffectController
      // );
      // slotMachineMagnificationRoller.add(magnificationMoveEffect);
    }
  }

  void stopSpinning(){
    // print("stopSpinning");
    // print(rollerState);
    slotMachineBlocksRollerFirstEffectController.setToStart();
    slotMachineBlocksRollerSecondEffectController.setToStart();
    slotMachineBlocksRollerThirdEffectController.setToStart();
    // slotMachineBlocksRollerFirstEffectController.setToStart();
    // slotMachineMagnificationRollerEffectController.setToStart();
    // magnificationMoveEffect.reset();
    rollerState = RollerState.stopped;


    //方块行换方块
    blocksRollerFirst.clear();
    blocksRollerSecond.clear();
    blocksRollerSecond.clear();
    rollersList.clear();
    rollersList.add(blocksRollerFirst);
    rollersList.add(blocksRollerSecond);
    rollersList.add(blocksRollerThird);
    for(int i = 0;i < 3;i++){
      addBlocks(rollersList[i],BlockType.block);
    }
    slotMachineBlocksFirstRoller = SlotMachineBlocksRoller(position: Vector2(-268, -96), blocksRoller: blocksRollerFirst, blocksPositions: blocksPositions);
    slotMachineBlocksSecondRoller = SlotMachineBlocksRoller(position: Vector2(-272, -96), blocksRoller: blocksRollerSecond, blocksPositions: blocksPositions);
    slotMachineBlocksThirdRoller = SlotMachineBlocksRoller(position: Vector2(-276, -96), blocksRoller: blocksRollerThird, blocksPositions: blocksPositions);

    //倍率行换方块
    // slotMachineMagnificationRoller.removeAll(slotMachineMagnificationRoller.children.whereType<Effect>());
    // magnification = [];
    // addBlocks(magnification, BlockType.magnification);
    // slotMachineMagnificationRoller = SlotMachineMagnificationRoller(position: Vector2(200,-100), blocksRoller: magnification, blocksPositions: magnificationPositions);
    // print(slotMachineMagnificationRoller);

  }

}
