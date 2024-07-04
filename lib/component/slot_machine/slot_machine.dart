import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/component/button/auto_spin_button.dart';
import 'package:fortune_game/component/button/bet/bet_button.dart';
import 'package:fortune_game/component/button/ex_bg_button.dart';
import 'package:fortune_game/component/button/ex_button.dart';
import 'package:fortune_game/component/button/quick_start_button.dart';
import 'package:fortune_game/component/button/setting_button.dart';
import 'package:fortune_game/component/ex_animation/ex_animation.dart';
import 'package:fortune_game/component/ex_animation/ex_tag.dart';
import 'package:fortune_game/component/marquee/marquee_text.dart';
import 'package:fortune_game/component/roller/gameview_component.dart';
import 'package:fortune_game/component/roller/slot_machine_blocks_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_magnification_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/component/button/spin_button.dart';
import 'package:fortune_game/component/roller/win_magnification_block.dart';
import 'package:fortune_game/component/system_alert/big_win.dart';
import 'package:fortune_game/component/system_alert/frame_win_bg.dart';
import 'package:fortune_game/component/system_alert/line_hint.dart';
import 'package:fortune_game/component/system_alert/mega_win.dart';
import 'package:fortune_game/component/system_alert/super_win.dart';
import 'package:fortune_game/component/system_alert/system_alert.dart';
import 'package:fortune_game/component/system_alert/system_explanation.dart';
import 'package:fortune_game/models/game_response_model.dart';
import 'package:fortune_game/symbol/demo_json.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/parameter.dart';
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

  late MoveEffect exButtonOpenMoveEffect;
  late MoveEffect exButtonCloseMoveEffect;

  late List<Component> firstComponents;
  late List<Component> secondComponents;
  late List<Component> thirdComponents;
  late List<Component> magnificationComponents;

  late PositionComponent clipComponentFirst;
  late ClipComponent clipComponentSecond;
  late ClipComponent clipComponentThird;
  late ClipComponent clipComponentMagnification;

  late EffectController slotMachineBlocksRollerFirstEffectController;
  late EffectController slotMachineBlocksRollerSecondEffectController;
  late EffectController slotMachineBlocksRollerThirdEffectController;
  late EffectController slotMachineMagnificationRollerEffectController;

  late EffectController eXButtonOpenEffectController;
  late EffectController eXButtonCloseEffectController;

  late SpriteComponent winFirstRowLine;
  late SpriteComponent winSecondRowLine;
  late SpriteComponent winThirdRowLine;
  late SpriteComponent winForthRowLine;
  late SpriteComponent windFifthRowLine;
  List<SpriteComponent> winLines = [];

  //當前滾動狀態。
  RollerState rollerState = RollerState.stopped;

  //统计每回合连线成功获得分数
  List<int> getPointsList = [];

  //初始下注金额
  String bettingAmount = '3';

  //初始余额
  String balance = '2000';

  //每回合获得的金币
  String roundWinPoints = '0';

  late TextComponent roundWinPointsTextComponent;

  late TextComponent balanceTextComponent;

  bool isWin = false;

  //系统讯息（馀额不足）
  late SpriteComponent systemAlert;

  late SpriteComponent autoSpinButton;

  bool isQuickSpinning = false;

  bool isOpenExButton = false;
  late SpriteComponent exBgSpriteComponent;

  //ex标签
  late SpriteComponent exTag;

  //连线成功提示
  late SpriteComponent frameWinBg;
  late SpriteComponent lineHint;
  late PositionComponent bigWin;
  late PositionComponent megaWin;
  late PositionComponent superWin;

  late MoveEffect effect;
  late MoveEffect effect1;

  late WinMagnificationBlock winSlotMachineRollerMagnificationBlock;

  bool firstRollerSpinning = false;
  bool secondRollerSpinning = false;
  bool thirdRollerSpinning = false;
  bool magnificationRollerSpinning = false;
  bool isCanSpin = true;

  late SpriteComponent systemExplanation;

  int count = 0;

  List<int> positionIndexList = [0,1,2,3,4,5,6,7,8];

  @override
  Future<void> onLoad() async {
    await init();

    slotMachineFrame = SpriteComponent(
      sprite: await Sprite.load('slot_machine.png'),
      anchor: Anchor.topCenter,
      scale: Vector2(0.73,0.73),
      position: Vector2(0,-180)
    );
    add(slotMachineFrame);

    //拉霸机上面bar上分的Ex
    add(ExButton(onTap: () {
      isOpenExButton = !isOpenExButton;
      if(isOpenExButton){
        openExButton();
      }else{
        closeExButton();
      }
    }));

    //拉霸机上面bar上分的Ex背景
    List<Component> list = [exBgSpriteComponent];
    add(ClipComponent.rectangle(position: Vector2(-110,-180),size: Vector2(290, 50),anchor: Anchor.bottomCenter,children: list));

    //拉霸机上面的bar
    add(SpriteComponent(
        sprite: await Sprite.load('bar.png'),
        anchor: Anchor.bottomCenter,
        size: Vector2(568,100),
        position: Vector2(0, -80)
    ));

    //跑马灯
    add(MarqueeText());

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
      size: Vector2(730,200),
      position: Vector2(0,200),
      anchor: Anchor.topCenter,
    ));

    //方块行
    add(clipComponentFirst);
    add(clipComponentSecond);
    add(clipComponentThird);

    //倍率行
    add(clipComponentMagnification);

    //倍率行方块框
    add(SpriteComponent(
      sprite: await Sprite.load('block_frame.png'),
      size: Vector2(145,115),
      position: Vector2(205, 0),
      anchor: Anchor.topCenter,
    ));

    //设定按钮
    add(SettingButton(onTap: (){
      print('设定按钮');
    }));

    //下注按钮
    add(BetButton(onTap: (betNumber){
      bettingAmount = betNumber;
      print('下注金额：$betNumber');
    }));

    //WIN(每局获得的金币)
    add(TextComponent(
      anchor: Anchor.topCenter,
      text: 'WIN',
        textRenderer: TextPaint(
            style : const TextStyle(
                fontSize: 33,
                color: Colors.amber
            )
        ),
      position: Vector2(-90, 213),
    ));

    add(roundWinPointsTextComponent);

    //开始转动按钮
    add(SpinButton(onTap: (){
      if(rollerState == RollerState.stopped && !Parameter.isAutoSpinMode){
        startSpinning();
      }
    }));

    //连续转动按钮
    add(autoSpinButton);

    //快速开始
    add(QuickStartButton(onTap: (){
      Parameter.isOpenQuickMode = !Parameter.isOpenQuickMode;
      print('QuickMode: ${Parameter.isOpenQuickMode}');
      if(Parameter.isOpenQuickMode){
        Parameter.firstRollerRepeatTimes = 2;
        Parameter.secondRollerRepeatTimes = 2;
        Parameter.thirdRollerRepeatTimes = 2;
        Parameter.magnificationRollerRepeatTimes = 2;
      }else{
        Parameter.firstRollerRepeatTimes = 3;
        Parameter.secondRollerRepeatTimes = 4;
        Parameter.thirdRollerRepeatTimes = 5;
        Parameter.magnificationRollerRepeatTimes = 6;
      }
    }));

    //余额显示
    balanceTextComponent = TextComponent(
      anchor: Anchor.topCenter,
      text: 'Balance  $balance',
      scale: Vector2(0.8,0.8),
      position: Vector2(0, 343),
    );
    add(balanceTextComponent);

    add(GameViewClipComponent(onTap: (){
      startSpinning();
    }));

    super.onLoad();
  }

  //初始化
  Future<void> init() async {
    exBgSpriteComponent = ExBgButton(onTap: (value){
      Map map = value;
      if(map['switchSprite'] && !Parameter.isOpenExMode){
        Parameter.isOpenExMode = true;
        slotMachineBlocksFirstRoller.changeExMode(0);
        slotMachineBlocksSecondRoller.changeExMode(1);
        slotMachineBlocksThirdRoller.changeExMode(2);
        exTag = ExTag();
        add(exTag);
        add(ExAnimation());
        //移除winLine
        for(int i = 0;i<winLines.length;i++){
          if(winLines[i].isMounted){
            remove(winLines[i]);
          }
        }
        // for(int i = 0;i<slotMachineBlocksFirstRoller.defaultBlocks.length;i++){
        //     SlotMachineRollerBlock slotMachineRollerFirstBlock = slotMachineBlocksFirstRoller.defaultBlocks[i];
        //     SlotMachineRollerBlock slotMachineRollerSecondBlock = slotMachineBlocksSecondRoller.defaultBlocks[i];
        //     SlotMachineRollerBlock slotMachineRollerThirdBlock = slotMachineBlocksThirdRoller.defaultBlocks[i];
        //     SlotMachineRollerBlock slotMachineMagnificationRollerBlock = slotMachineMagnificationRoller.defaultBlocks[i];
        //     slotMachineRollerFirstBlock.removeMask();
        //     slotMachineRollerSecondBlock.removeMask();
        //     slotMachineRollerThirdBlock.removeMask();
        //     slotMachineMagnificationRollerBlock.removeMask();
        // }
        Future.delayed(const Duration(seconds: 1), () {
          changeExMode();
        });
      }else if( !map['switchSprite'] && Parameter.isOpenExMode){
        Parameter.isOpenExMode = false;
        if(exTag.isMounted){
          remove(exTag);
          slotMachineMagnificationRoller.revertRoller();
          slotMachineBlocksFirstRoller.revertRoller();
          slotMachineBlocksSecondRoller.revertRoller();
          slotMachineBlocksThirdRoller.revertRoller();
        }
      }
      if(map['exQuestionSprite']){
        if(!isOpenExButton){
          isOpenExButton = !isOpenExButton;
          openExButton();
          Future.delayed(const Duration(milliseconds: 350), () {
            add(systemExplanation);
          });
        }else{
          add(systemExplanation);
        }

      }else{
        if(systemExplanation.isMounted){
          remove(systemExplanation);
        }
      }
    });

    roundWinPointsTextComponent = TextComponent(
      anchor: Anchor.topCenter,
      text: roundWinPoints,
      textRenderer: TextPaint(
          style : const TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold,
              color: Colors.white
          )
      ),
      position: Vector2(0, 213),
    );

    eXButtonOpenEffectController = LinearEffectController(0.35);
    eXButtonCloseEffectController = LinearEffectController(0.35);

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

    clipComponentFirst = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(-138,-100), size: Vector2(143, 290), children: firstComponents);
    clipComponentSecond = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(4,-100), size: Vector2(143, 290), children: secondComponents);
    clipComponentThird = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(146,-100), size: Vector2(143, 290), children: thirdComponents);

    //倍率行
    addBlocks(magnification, BlockType.magnification);
    slotMachineMagnificationRoller = SlotMachineMagnificationRoller(position: Vector2(200,-100), blocksRoller: magnification, blocksPositions: SymbolBlocks().magnificationPositions);
    magnificationComponents = [slotMachineMagnificationRoller];

    clipComponentMagnification = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(275,-100), size: Vector2(130, 300), children: magnificationComponents);


    //连线
    winFirstRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_1.png'),
        size: Vector2(460,426),
        position: Vector2(-290,-150)
    );

    winSecondRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_2.png'),
        size: Vector2(460,426),
        position: Vector2(-290,-110)
    );

    winThirdRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_3.png'),
        size: Vector2(460,426),
        position: Vector2(-290,-210)
    );

    winForthRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_4.png'),
        size: Vector2(460,207),
        position: Vector2(-290,-55)
    );

    windFifthRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_5.png'),
        size: Vector2(460,207),
        position: Vector2(-290,-55)
    );

    systemAlert = SystemAlert(onTap: (){
      remove(systemAlert);
    });

    autoSpinButton = AutoSpinButton(onTap: (){
      print('连续转动');
      if(!Parameter.isAutoSpinMode){
        startSpinning();
      }
    });

    exTag = ExTag();
    systemExplanation = SystemExplanation();

  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if(rollerState == RollerState.rolling){
      if(!slotMachineBlocksRollerFirstEffectController.completed){
        slotMachineBlocksFirstRoller.refreshBlocks();
      }
      if(!slotMachineBlocksRollerSecondEffectController.completed){
        slotMachineBlocksSecondRoller.refreshBlocks();
      }
      if(!slotMachineBlocksRollerThirdEffectController.completed){
        slotMachineBlocksThirdRoller.refreshBlocks();
      }
      if(!slotMachineMagnificationRollerEffectController.completed){
        slotMachineMagnificationRoller.refreshBlocks();
      }
      if(slotMachineBlocksRollerFirstEffectController.completed){
        // print('方块第一行停止转动');
        stopSpinning(RollerType.firstRoller);
      }
      if(slotMachineBlocksRollerSecondEffectController.completed){
        // print('方块第二行停止转动');
        stopSpinning(RollerType.secondRoller);
      }
      if(slotMachineBlocksRollerThirdEffectController.completed){
        // print('方块第三行停止转动');
        stopSpinning(RollerType.thirdRoller);
      }
      if(slotMachineMagnificationRollerEffectController.completed){
        // print('倍率方块停止转动');
        stopSpinning(RollerType.magnificationRoller);
      }
    }

    if(eXButtonOpenEffectController.completed){
      restExcButtonEffect(exButtonOpenMoveEffect);
    }

    if(eXButtonCloseEffectController.completed){
      restExcButtonEffect(exButtonCloseMoveEffect);
    }

  }

  void restExcButtonEffect(MoveEffect moveEffect){
    moveEffect.reset();
  }

  //打开Ex按钮
  Future<void> openExButton() async {
    exButtonOpenMoveEffect = MoveEffect.to(
        Vector2(exBgSpriteComponent.position.x+203, exBgSpriteComponent.position.y),
        eXButtonOpenEffectController);
    exBgSpriteComponent.add(exButtonOpenMoveEffect);
  }

  //关闭Ex按钮
  Future<void> closeExButton() async {
    exBgSpriteComponent.removeAll(exBgSpriteComponent.children.whereType<Effect>());
    exButtonCloseMoveEffect = MoveEffect.to(
        Vector2(exBgSpriteComponent.position.x-203, exBgSpriteComponent.position.y),
        eXButtonCloseEffectController);
    exBgSpriteComponent.add(exButtonCloseMoveEffect);
    if(systemExplanation.isMounted){
      remove(systemExplanation);
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
        // image:  'blocks/symbol_wild.png',
        anchor: Anchor.topCenter,
        position: positions[i],
        blockType: blockType,
        rollerIndex: i,
      );
      blocks.add(block);
    }
  }

  //开始转动
  Future<void> startSpinning() async {
    if(int.parse(bettingAmount) <= int.parse(balance)){
      if(isCanSpin){
        isCanSpin = false;
        count++;
        roundWinPoints = '0';
        firstRollerSpinning = true;
        secondRollerSpinning = true;
        thirdRollerSpinning = true;
        magnificationRollerSpinning = true;
        slotMachineMagnificationRoller.defaultBlocks = [];
        slotMachineBlocksFirstRoller.defaultBlocks = [];
        slotMachineBlocksSecondRoller.defaultBlocks = [];
        slotMachineBlocksThirdRoller.defaultBlocks = [];
        Parameter.isOpenBetOption = false;
        isOpenExButton = false;
        closeExButton();
        setRoundWinComponents('0');
        print('单次转动');
        print('开始转动');
        //重置位置，方便后续计算哪些需要遮罩
        positionIndexList = [0,1,2,3,4,5,6,7,8];
        //移除winLine
        for(int i = 0;i<winLines.length;i++){
          if(winLines[i].isMounted){
            remove(winLines[i]);
          }
        }
        winLines = [];
        slotMachineBlocksFirstRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<RectangleComponent>());
        slotMachineBlocksSecondRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<RectangleComponent>());
        slotMachineBlocksThirdRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<RectangleComponent>());
        slotMachineMagnificationRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<RectangleComponent>());
        isWin = false;
        getPointsList = [];
        rollerState = RollerState.rolling;
        slotMachineBlocksRollerFirstEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.firstRollerRepeatTimes);
        slotMachineBlocksRollerSecondEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.secondRollerRepeatTimes);
        slotMachineBlocksRollerThirdEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.thirdRollerRepeatTimes);
        slotMachineMagnificationRollerEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.magnificationRollerRepeatTimes);


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

    }else{
      //馀额不足
      isQuickSpinning = false;
      remove(autoSpinButton);
      add(systemAlert);
      add(autoSpinButton);
    }
  }

  //停止转动
  Future<void> stopSpinning(RollerType rollerType) async {
    // 重置MoveEffect
    // 移除所有Effect
    //重新赋予方块
    //重新赋予位置
    switch (rollerType) {
      case RollerType.firstRoller:
        if(firstRollerSpinning){
          slotMachineBlocksFirstRoller.getLastResultBlocks(count,RollerType.firstRoller);
          slotMachineBlocksFirstRoller.position = Vector2(-268, -76);
          //回弹效果
          MoveEffect moveEffect = MoveEffect.to(Vector2(slotMachineBlocksFirstRoller.position.x,slotMachineBlocksFirstRoller.position.y-20),EffectController(duration: 0.35,curve: Curves.easeInOut),onComplete: (){
            slotMachineBlocksFirstRoller.removeAll(slotMachineBlocksFirstRoller.children.whereType<Effect>());
          });
          slotMachineBlocksFirstRoller.add(moveEffect);
        }
        firstRollerSpinning = false;
        break;
      case RollerType.secondRoller:
        if(secondRollerSpinning){
          slotMachineBlocksSecondRoller.getLastResultBlocks(count,RollerType.secondRoller);
          slotMachineBlocksSecondRoller.position = Vector2(-272, -76);
          //回弹效果
          MoveEffect moveEffect = MoveEffect.to(Vector2(slotMachineBlocksSecondRoller.position.x,slotMachineBlocksSecondRoller.position.y-20),EffectController(duration: 0.35,curve: Curves.easeInOut),onComplete: (){
            slotMachineBlocksSecondRoller.removeAll(slotMachineBlocksSecondRoller.children.whereType<Effect>());
          });
          slotMachineBlocksSecondRoller.add(moveEffect);
        }
        secondRollerSpinning = false;
        break;
      case RollerType.thirdRoller:
        if(thirdRollerSpinning){
          slotMachineBlocksThirdRoller.getLastResultBlocks(count,RollerType.thirdRoller);
          slotMachineBlocksThirdRoller.position = Vector2(-276, -76);
          //回弹效果
          MoveEffect moveEffect = MoveEffect.to(Vector2(slotMachineBlocksThirdRoller.position.x,slotMachineBlocksThirdRoller.position.y-20),EffectController(duration: 0.35,curve: Curves.easeInOut),onComplete: (){
            slotMachineBlocksThirdRoller.removeAll(slotMachineBlocksThirdRoller.children.whereType<Effect>());
          });
          slotMachineBlocksThirdRoller.add(moveEffect);
        }
        thirdRollerSpinning = false;
        break;
      case RollerType.magnificationRoller:
        rollerState = RollerState.stopped;
        slotMachineMagnificationRoller.getLastResultBlocks(count,RollerType.magnificationRoller);
        slotMachineMagnificationRoller.position = Vector2(200,-80);
        //回弹效果
        MoveEffect moveEffect = MoveEffect.to(Vector2(slotMachineMagnificationRoller.position.x,slotMachineMagnificationRoller.position.y- 20),EffectController(duration: 0.35,curve: Curves.easeInOut),onComplete: (){
          slotMachineMagnificationRoller.removeAll(slotMachineMagnificationRoller.children.whereType<Effect>());
          firstMoveEffect.reset();
          secondMoveEffect.reset();
          thirdMoveEffect.reset();
          magnificationMoveEffect.reset();
          magnificationRollerSpinning = false;
          // checkWin();
          newCheckWin();
          if(Parameter.isAutoSpinMode){
            int delay = (isWin)?13:1;
            Future.delayed(Duration(seconds: delay), () {
              startSpinning();
            });
          }
        });
        slotMachineMagnificationRoller.add(moveEffect);
        break;
    }
  }

  //测试假JSON数据
  void newCheckWin(){
    List demoJsonList = DemoJson().demoJsonList;
    // bool useListIndexOne = determineEven(count);
    GameResponse gameResponse;
    gameResponse = GameResponse.fromJson(demoJsonList[Parameter.jsonCount % demoJsonList.length]);
    Parameter.jsonCount++;
    setBalanceTextComponent(gameResponse.resultMap.cashBalance.toString());
    if(gameResponse.resultMap.detail[0].result.isNotEmpty){
      roundWinPoints = gameResponse.resultMap.totalWinAmount.toString();
      setRoundWinComponents(roundWinPoints);
      showWinHint(gameResponse);
    }else{
     print('未成功连线');
     isCanSpin = true;
    }
  }

  //显示获胜提示
  Future<void> showWinHint(GameResponse gameResponse) async {
    //显示连线
    List<GameResult> gameResultsList = gameResponse.resultMap.detail[0].result;
    gameResultsList.sort((a, b) => a.line.compareTo(b.line));
    gameResultsList.forEach((gameResult) => showLine(gameResult.line));
    //遮罩
    for(int i =0;i<winLines.length;i++){
      if(winLines[i] == winFirstRowLine){
        positionIndexList.remove(3);
        positionIndexList.remove(4);
        positionIndexList.remove(5);
      }else if(winLines[i] == winSecondRowLine){
        positionIndexList.remove(0);
        positionIndexList.remove(1);
        positionIndexList.remove(2);
      }else if(winLines[i] == winThirdRowLine){
        positionIndexList.remove(6);
        positionIndexList.remove(7);
        positionIndexList.remove(8);
      }else if(winLines[i] == winForthRowLine){
        positionIndexList.remove(0);
        positionIndexList.remove(4);
        positionIndexList.remove(9);
      }else{
        positionIndexList.remove(6);
        positionIndexList.remove(4);
        positionIndexList.remove(2);
      }
    }
    addMask(false);

    //显示奖励金额
    int ratio = gameResponse.resultMap.detail[0].ratio;
    int totalWinAmount = gameResponse.resultMap.totalWinAmount;
    roundWinPoints = totalWinAmount.toString();
    int bettingAmountInt = gameResponse.resultMap.betAmount;
    bettingAmount = bettingAmountInt.toString();
    frameWinBg = FrameWinBg(score: (totalWinAmount/ratio).toString(), bettingOdds: bettingAmount, needAnimation: true);
    //不知为何第一次会add会比较慢出现甚至来不及出现，故加入await
    await add(frameWinBg);

    //显示奖励金额横幅
    Map<String,Map> map = {};
    for(int i = 0;i<gameResultsList.length;i++){
      GameResult gameResult = gameResultsList[i];
      String item = gameResult.item;
      Map? detailMap = map[item];
      if(detailMap == null){
        int count  = 1;
        int amount = gameResult.playResult;
        int odd = gameResult.odd;
        Map denialMap = {'count':count, 'amount':amount, 'odd':odd};
        map[item] = denialMap;
        print(map);
      }else{
        int count  = detailMap['count'] + 1;
        int amount = detailMap['amount'] + gameResult.playResult;
        int odd = detailMap['odd'];
        Map denialMap = {'count':count, 'amount':amount, 'odd':odd};
        map[item] = denialMap;
      }
    }
    int lineHintCount = 0;
    if(totalWinAmount <= bettingAmountInt*5){
      map.forEach((key, value) {
        int count = value['count'];
        int amount = value['amount'];
        int odd = value['odd'];
        double result1 = (odd/5);
        double showOdd = result1* int.parse(bettingAmount);
        LineHint lineHint = LineHint(block: key, magnification: ratio.toString(),bettingOdds: showOdd.toString(), lines: count.toString(), score: amount.toString(), lineHintCount: lineHintCount);
        add(lineHint);
        lineHintCount++;
      });
    }
    showMagnificationBlock(totalWinAmount.toString(), bettingAmountInt);

    // await Future.delayed(Duration(seconds: 3));
    // BigMegaSuperWin bigMegaSuperWin = BigMegaSuperWin(startNumber: bettingAmount, endNumber: totalWinAmount.toString(), showCount: 3);
    // add(bigMegaSuperWin);


    await Future.delayed(Duration(milliseconds: 1500));
    if(totalWinAmount >= bettingAmountInt*5){
      if(totalWinAmount >= bettingAmountInt*15-1){
        BigWin bigWin = BigWin(startNumber: bettingAmount, endNumber:(bettingAmountInt*15-1).toString());
        add(bigWin);
        carouselLines();
      }else{
        BigWin bigWin = BigWin(startNumber: bettingAmount, endNumber: totalWinAmount.toString());
        add(bigWin);
      }
    }else{
      if(Parameter.isAutoSpinMode){
        await Future.delayed(Duration(seconds: 2));
        isCanSpin = true;
        startSpinning();
      }else{
        isCanSpin = true;
      }
      return;
    }
    await Future.delayed(Duration(seconds: 3));
    if(totalWinAmount >= bettingAmountInt*15){
      if(totalWinAmount > bettingAmountInt*30-1){
        MegaWin megaWin = MegaWin(startNumber: (bettingAmountInt*15).toString(), endNumber: (bettingAmountInt*30 -1).toString());
        add(megaWin);
      }else{
        MegaWin megaWin = MegaWin(startNumber: (bettingAmountInt*15).toString(), endNumber: (bettingAmountInt*30 -1).toString());
        add(megaWin);
      }
    }
    await Future.delayed(Duration(seconds: 3));
    if(totalWinAmount >= bettingAmountInt*30){
      SuperWin superWin = SuperWin(startNumber: (bettingAmountInt*30).toString(), endNumber: totalWinAmount.toString());
      add(superWin);
    }

    if(Parameter.isAutoSpinMode){
      await Future.delayed(Duration(seconds: 4));
      isCanSpin = true;
      startSpinning();
    }else{
      await Future.delayed(Duration(seconds: 3));
      isCanSpin = true;
    }
  }

  //轮播连线
  Future<void> carouselLines() async {
    for(int i = 0;i<winLines.length;i++){
      if(winLines[i].isMounted){
        remove(winLines[i]);
      }
    }
    carouselLinesStart();
  }

  //轮播连线逻辑（添加删除遮罩）
  void carouselLinesStart(){
    SpriteComponent spriteComponent = winLines.first;
    add(spriteComponent);
    positionIndexList = [0,1,2,3,4,5,6,7,8];
    if(spriteComponent == winFirstRowLine){
      positionIndexList.remove(3);
      positionIndexList.remove(4);
      positionIndexList.remove(5);
    }else if(spriteComponent == winSecondRowLine){
      positionIndexList.remove(0);
      positionIndexList.remove(1);
      positionIndexList.remove(2);
    }else if(spriteComponent == winThirdRowLine){
      positionIndexList.remove(6);
      positionIndexList.remove(7);
      positionIndexList.remove(8);
    }else if(spriteComponent == winForthRowLine){
      positionIndexList.remove(0);
      positionIndexList.remove(4);
      positionIndexList.remove(8);
    }else{
      positionIndexList.remove(6);
      positionIndexList.remove(4);
      positionIndexList.remove(2);
    }
    addMask(true);
    Future.delayed(const Duration(seconds: 2), () {
      remove(spriteComponent);
      winLines.removeAt(0);
      winLines.add(spriteComponent);
      for(int i = 0;i<slotMachineBlocksFirstRoller.blocksRoller.length;i++){
            SlotMachineRollerBlock slotMachineRollerFirstBlock = slotMachineBlocksFirstRoller.blocksRoller[i];
            SlotMachineRollerBlock slotMachineRollerSecondBlock = slotMachineBlocksSecondRoller.blocksRoller[i];
            SlotMachineRollerBlock slotMachineRollerThirdBlock = slotMachineBlocksThirdRoller.blocksRoller[i];
            slotMachineRollerFirstBlock.removeMask();
            slotMachineRollerSecondBlock.removeMask();
            slotMachineRollerThirdBlock.removeMask();
      }
      carouselLinesStart();
    });
  }

  //显示连线
  void showLine(int line){
    switch (line) {
      case 1:
        add(winFirstRowLine);
        winLines.add(winFirstRowLine);
        break;
      case 2:
        add(winSecondRowLine);
        winLines.add(winSecondRowLine);
        break;
      case 3:
        add(winThirdRowLine);
        winLines.add(winThirdRowLine);
        break;
      case 4:
        add(winForthRowLine);
        winLines.add(winForthRowLine);
        break;
      case 5:
        add(windFifthRowLine);
        winLines.add(windFifthRowLine);
        break;
    }
  }

  //添加遮罩
  Future<void> addMask(bool isCarouselLines) async {
    print(positionIndexList);
    for(int i = 0 ;i<positionIndexList.length;i++){
      switch (positionIndexList[i]) {
        case 0:
          slotMachineBlocksFirstRoller.blocksRoller[2].addMask();
          break;
        case 1:
          slotMachineBlocksSecondRoller.blocksRoller[2].addMask();
          break;
        case 2:
          slotMachineBlocksThirdRoller.blocksRoller[2].addMask();
          break;
        case 3:
          slotMachineBlocksFirstRoller.blocksRoller[3].addMask();
          break;
        case 4:
          slotMachineBlocksSecondRoller.blocksRoller[3].addMask();
          break;
        case 5:
          slotMachineBlocksThirdRoller.blocksRoller[3].addMask();
          break;
        case 6:
          slotMachineBlocksFirstRoller.blocksRoller[4].addMask();
          break;
        case 7:
          slotMachineBlocksSecondRoller.blocksRoller[4].addMask();
          break;
        case 8:
          slotMachineBlocksThirdRoller.blocksRoller[4].addMask();
          break;
      }
    }

    if(!isCarouselLines){
      for(int i = 0;i<slotMachineMagnificationRoller.blocksRoller.length;i++){
        if(i != 3){
          slotMachineMagnificationRoller.blocksRoller[i].addMask();
        }
      }
    }
  }

  void changeExMode(){
    slotMachineMagnificationRoller.changeExMode();
  }

  //成功连线后倍率方块的动画效果
  void showMagnificationBlock(String totalWinAmount, int bettingAmountInt){
    SlotMachineRollerBlock slotMachineRollerMagnificationBlock = slotMachineMagnificationRoller.blocksRoller[3];
    winSlotMachineRollerMagnificationBlock = WinMagnificationBlock(image: slotMachineRollerMagnificationBlock.image);
    add(winSlotMachineRollerMagnificationBlock);
    Future.delayed(const Duration(seconds: 1), () {
      EffectController effectController = EffectController(duration: 0.3, curve: Curves.linear);
      MoveEffect moveEffect = MoveEffect.to(Vector2(winSlotMachineRollerMagnificationBlock.position.x-270, winSlotMachineRollerMagnificationBlock.position.y),
          effectController,onComplete: (){
            remove(frameWinBg);
            if(double.parse(totalWinAmount) <= bettingAmountInt*5){
              frameWinBg = FrameWinBg(score: totalWinAmount, bettingOdds: bettingAmount, needAnimation: false);
              add(frameWinBg);
              Future.delayed( Duration(milliseconds: (double.parse(totalWinAmount) <= bettingAmountInt*5)?1750:3000), () {
                remove(frameWinBg);
              });
              winSlotMachineRollerMagnificationBlock.removeAll(exBgSpriteComponent.children.whereType<Effect>());
              remove(winSlotMachineRollerMagnificationBlock);
            }
          });
      winSlotMachineRollerMagnificationBlock.add(moveEffect);
    });
  }

  void setRoundWinComponents(String text){
    remove(roundWinPointsTextComponent);
    roundWinPointsTextComponent = TextComponent(
      anchor: Anchor.topCenter,
      text: text,
      textRenderer: TextPaint(
          style : const TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold,
              color: Colors.white
          )
      ),
      position: Vector2(0, 213),
    );
    add(roundWinPointsTextComponent);
  }

  void setBalanceTextComponent(String text){
    remove(balanceTextComponent);
    balanceTextComponent = TextComponent(
      anchor: Anchor.topCenter,
      text: 'Balance  $text',
      scale: Vector2(0.8,0.8),
      position: Vector2(0, 343),
    );
    add(balanceTextComponent);
  }

}
