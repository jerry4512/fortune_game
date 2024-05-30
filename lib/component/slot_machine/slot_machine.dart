
import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/component/button/auto_spin_button.dart';
import 'package:fortune_game/component/button/bet_button.dart';
import 'package:fortune_game/component/button/ex_button.dart';
import 'package:fortune_game/component/button/quick_start_button.dart';
import 'package:fortune_game/component/button/setting_button.dart';
import 'package:fortune_game/component/marquee/spin_button.dart';
import 'package:fortune_game/component/roller/slot_machine_blocks_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_magnification_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/component/button/spin_button.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';


class SlotMachine extends PositionComponent {

  SlotMachine() : super();

  late SpriteComponent slotMachineFrame;

  List<List<SlotMachineRollerBlock>> rollersList = [];
  List<SlotMachineRollerBlock> blocksRollerFirst = [];
  List<SlotMachineRollerBlock> blocksRollerSecond = [];
  List<SlotMachineRollerBlock> blocksRollerThird= [];
  List<SlotMachineRollerBlock> magnification = [];

  late SlotMachineBlocksRoller slotMachineBlocksFirstRoller;
  late SlotMachineBlocksRoller slotMachineBlocksSecondRoller;
  late SlotMachineBlocksRoller slotMachineBlocksThirdRoller;
  late SlotMachineMagnificationRoller slotMachineMagnificationRoller;

  late MoveEffect firstMoveEffect;
  late MoveEffect secondMoveEffect;
  late MoveEffect thirdMoveEffect;
  late MoveEffect magnificationMoveEffect;

  late List<Component> firstComponents;
  late List<Component> secondComponents;
  late List<Component> thirdComponents;
  late List<Component> magnificationComponents;

  late ClipComponent clipComponentFirst;
  late ClipComponent clipComponentSecond;
  late ClipComponent clipComponentThird;
  late ClipComponent clipComponentMagnification;

  late EffectController slotMachineBlocksRollerFirstEffectController;
  late EffectController slotMachineBlocksRollerSecondEffectController;
  late EffectController slotMachineBlocksRollerThirdEffectController;
  late EffectController slotMachineMagnificationRollerEffectController;

  late SpriteComponent winFirstRowLine;
  late SpriteComponent winSecondRowLine;
  late SpriteComponent winThirdRowLine;
  late SpriteComponent winForthRowLine;
  late SpriteComponent windFifthRowLine;

  //當前滾動狀態。
  RollerState rollerState = RollerState.stopped;

  //是否是连续转动
  bool isContinuousSpinning = false;

  String balance = '99999';

  @override
  Future<void> onLoad() async {
    init();

    slotMachineFrame = SpriteComponent(
      sprite: await Sprite.load('slot_machine.png'),
      anchor: Anchor.topCenter,
      scale: Vector2(0.73,0.73),
      position: Vector2(0,-180)
    );
    add(slotMachineFrame);

    //拉霸机上面bar上分的Ex
    add(ExButton(onTap: (){

    }));

    //拉霸机上面的bar
    add(SpriteComponent(
        sprite: await Sprite.load('bar.png'),
        anchor: Anchor.bottomCenter,
        size: Vector2(568,100),
        position: Vector2(0, -80)
    ));

    //跑马灯
    add(MarqueeText(onTap: (){}));

    //拉霸机倍率上面的文字
    add(SpriteComponent(
        sprite: await Sprite.load('magnification_bar_text.png'),
        anchor: Anchor.bottomCenter,
        size: Vector2(100,40),
        position: Vector2(208, -110)
    ));

    //拉霸机底部
    add(SpriteComponent(
      sprite: await Sprite.load('bottom.png'),
      size: Vector2(730,100),
      position: Vector2(0,200),
      anchor: Anchor.topCenter,
    ));


    clipComponentFirst = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(-135,-100), size: Vector2(143, 290), children: firstComponents);
    clipComponentSecond = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(7,-100), size: Vector2(143, 290), children: secondComponents);
    clipComponentThird = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(149,-100), size: Vector2(143, 290), children: thirdComponents);

    //方块行
    add(clipComponentFirst);
    add(clipComponentSecond);
    add(clipComponentThird);

    //倍率行
    clipComponentMagnification = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(275,-100), size: Vector2(130, 300), children: magnificationComponents);
    add(clipComponentMagnification);

    //设定按钮
    add(SettingButton(onTap: (){
      print('下注按钮');
    }));

    //下注按钮
    add(BetButton(onTap: (){
      print('下注按钮');
    }));

    //开始转动按钮
    add(SpinButton(onTap: (){
      if(rollerState == RollerState.stopped && !isContinuousSpinning){
        print('单次转动');
        startSpinning();
      }
    }));

    //连续转动按钮
    add(AutoSpinButton(onTap: (){
      print('连续转动');
      if(isContinuousSpinning){
        isContinuousSpinning = false;
        stopSpinning();
      }else{
        isContinuousSpinning = true;
        startSpinning();
      }
    }));

    //快速开始
    add(QuickStartButton(onTap: (){
      print('快速开始');
    }));

    add(TextComponent(
      anchor: Anchor.topCenter,
      text: 'Balance  $balance',
      scale: Vector2(0.8,0.8),
      position: Vector2(0, 273),
    ));

    // add(SpriteComponent(
    //     sprite: await Sprite.load('bet_options_frame.png')
    // ));

    super.onLoad();
  }

  //初始化
  Future<void> init() async {
    //初始化EffectController
    slotMachineBlocksRollerFirstEffectController = RepeatedEffectController(LinearEffectController(0.15), 7);
    slotMachineBlocksRollerSecondEffectController = RepeatedEffectController(LinearEffectController(0.15), 7);
    slotMachineBlocksRollerThirdEffectController = RepeatedEffectController(LinearEffectController(0.15), 7);
    slotMachineMagnificationRollerEffectController = RepeatedEffectController(LinearEffectController(0.15), 7);

    //方块行放入一个List，方便之后操作
    rollersList.add(blocksRollerFirst);
    rollersList.add(blocksRollerSecond);
    rollersList.add(blocksRollerThird);
    //方块行添加方块
    for(int i = 0;i < 3;i++){
      addBlocks(rollersList[i],BlockType.block);
    }

    slotMachineBlocksFirstRoller = SlotMachineBlocksRoller(position: Vector2(-268, -96), blocksRoller: blocksRollerFirst, blocksPositions: SymbolBlocks().blocksPositions);
    slotMachineBlocksSecondRoller = SlotMachineBlocksRoller(position: Vector2(-272, -96), blocksRoller: blocksRollerSecond, blocksPositions: SymbolBlocks().blocksPositions);
    slotMachineBlocksThirdRoller = SlotMachineBlocksRoller(position: Vector2(-276, -96), blocksRoller: blocksRollerThird, blocksPositions: SymbolBlocks().blocksPositions);
    firstComponents =[slotMachineBlocksFirstRoller];
    secondComponents =[slotMachineBlocksSecondRoller];
    thirdComponents =[slotMachineBlocksThirdRoller];

    //倍率行
    addBlocks(magnification, BlockType.magnification);
    slotMachineMagnificationRoller = SlotMachineMagnificationRoller(position: Vector2(200,-100), blocksRoller: magnification, blocksPositions: SymbolBlocks().magnificationPositions);
    magnificationComponents = [slotMachineMagnificationRoller];

    //连线
    winFirstRowLine = SpriteComponent(
        sprite: await Sprite.load('/lines/line_1.png'),
    position: Vector2(-290,-260)
    );

    winSecondRowLine = SpriteComponent(
    sprite: await Sprite.load('/lines/line_2.png'),
    position: Vector2(-290,-20)
    );

    winThirdRowLine = SpriteComponent(
    sprite: await Sprite.load('/lines/line_3.png'),
    position: Vector2(-290,-210)
    );

    winForthRowLine = SpriteComponent(
        sprite: await Sprite.load('/lines/line_4.png'),
        size: Vector2(495,225),
        position: Vector2(-300,-50)
    );

    windFifthRowLine = SpriteComponent(
        sprite: await Sprite.load('/lines/line_5.png'),
        size: Vector2(495,225),
        position: Vector2(-300,-70)
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(slotMachineBlocksRollerFirstEffectController.completed && slotMachineBlocksRollerSecondEffectController.completed && slotMachineBlocksRollerThirdEffectController.completed && slotMachineMagnificationRollerEffectController.completed &&rollerState == RollerState.rolling){
      stopSpinning();
    }

  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }

  //添加方块
  void addBlocks(List<Component> blocks,BlockType type){
    List<String> defaultBlocksImageList = SymbolBlocks().blocksImageList;
    List<Vector2> positions = SymbolBlocks().blocksPositions;
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
        // image:  'blocks/symbol_07.png',
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
    print('开始转动');
    if(winFirstRowLine.isMounted){
      remove(winFirstRowLine);
    }else if(winSecondRowLine.isMounted){
      remove(winSecondRowLine);
    }else if(winThirdRowLine.isMounted){
      remove(winThirdRowLine);
    }else if(winForthRowLine.isMounted){
      remove(winForthRowLine);
    }else if(windFifthRowLine.isMounted){
      remove(windFifthRowLine);
    }

    rollerState = RollerState.rolling;
    firstMoveEffect = MoveEffect.to(
        Vector2(slotMachineBlocksFirstRoller.position.x, slotMachineBlocksFirstRoller.position.y + 200),
        slotMachineBlocksRollerFirstEffectController);
    slotMachineBlocksFirstRoller.add(firstMoveEffect);

    secondMoveEffect = MoveEffect.to(
        Vector2(slotMachineBlocksSecondRoller.position.x, slotMachineBlocksSecondRoller.position.y + 200),
        slotMachineBlocksRollerSecondEffectController);
    slotMachineBlocksSecondRoller.add(secondMoveEffect);

    thirdMoveEffect = MoveEffect.to(
        Vector2(slotMachineBlocksThirdRoller.position.x, slotMachineBlocksThirdRoller.position.y + 200),
        slotMachineBlocksRollerThirdEffectController);
    slotMachineBlocksThirdRoller.add(thirdMoveEffect);

    magnificationMoveEffect = MoveEffect.to(
        Vector2(slotMachineMagnificationRoller.position.x, slotMachineMagnificationRoller.position.y + 200),
        slotMachineMagnificationRollerEffectController);
    slotMachineMagnificationRoller.add(magnificationMoveEffect);


  }

  //停止转动
  void stopSpinning(){
    print('停止转动');
    rollerState = RollerState.stopped;
    // 重置MoveEffect
    firstMoveEffect.reset();
    secondMoveEffect.reset();
    thirdMoveEffect.reset();
    magnificationMoveEffect.reset();
    // 移除所有Effect
    slotMachineBlocksFirstRoller.removeAll(slotMachineBlocksFirstRoller.children.whereType<Effect>());
    slotMachineBlocksSecondRoller.removeAll(slotMachineBlocksSecondRoller.children.whereType<Effect>());
    slotMachineBlocksThirdRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<Effect>());
    slotMachineMagnificationRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<Effect>());

    //重新赋予方块
    slotMachineBlocksFirstRoller.refreshBlocks();
    slotMachineBlocksSecondRoller.refreshBlocks();
    slotMachineBlocksThirdRoller.refreshBlocks();
    slotMachineMagnificationRoller.refreshBlocks();

    //重新赋予位置
    slotMachineBlocksFirstRoller.position = Vector2(-268, -96);
    slotMachineBlocksSecondRoller.position = Vector2(-272, -96);
    slotMachineBlocksThirdRoller.position = Vector2(-276, -96);
    slotMachineMagnificationRoller.position = Vector2(200,-100);

    checkWin();

    if(isContinuousSpinning){
      Future.delayed(const Duration(seconds: 1), () {
        startSpinning();
      });

    }
  }

  void checkWin(){
    for(int i =2;i<blocksRollerFirst.length;i++){
      List<SlotMachineRollerBlock> slotMachineFirstRollerBlocks = slotMachineBlocksFirstRoller.blocksRoller;
      List<SlotMachineRollerBlock> slotMachineSecondRollerBlocks = slotMachineBlocksSecondRoller.blocksRoller;
      List<SlotMachineRollerBlock> slotMachineThirdRollerBlocks = slotMachineBlocksThirdRoller.blocksRoller;

      //判断横向是否有连线
      for(int i = 2;i<blocksRollerFirst.length;i++){
        String firstBlockImage = slotMachineFirstRollerBlocks[i].image;
        String secondBlockImage = slotMachineSecondRollerBlocks[i].image;
        String thirdBlockImage = slotMachineThirdRollerBlocks[i].image;
        print('----$i----');
        print(firstBlockImage);
        print(secondBlockImage);
        print(thirdBlockImage);
        if(firstBlockImage == secondBlockImage && firstBlockImage == thirdBlockImage){
          print('----横向有相同----');
          if(i == 2){
            add(winFirstRowLine);
          }else if(i == 3){
            add(winFirstRowLine);
          }else{
            add(winThirdRowLine);
          }
        }
      }

      //判断斜向是否有连线
      String firstSecondBlockImage = slotMachineFirstRollerBlocks[2].image;
      String firstForthBlockImage = slotMachineFirstRollerBlocks[4].image;
      String secondCenterBlockImage = slotMachineSecondRollerBlocks[3].image;
      String thirdSecondBlockImage = slotMachineThirdRollerBlocks[2].image;
      String thirdForthBlockImage = slotMachineThirdRollerBlocks[4].image;
      if(firstSecondBlockImage == secondCenterBlockImage && firstSecondBlockImage == thirdForthBlockImage){
        print('----左上右下斜向有相同----');
        add(winForthRowLine);
      }

      if(firstForthBlockImage == secondCenterBlockImage && firstForthBlockImage == thirdSecondBlockImage){
        print('----左下右上斜向有相同----');
        add(windFifthRowLine);
      }

    }
  }

}
