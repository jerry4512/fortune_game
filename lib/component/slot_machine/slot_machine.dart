import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/component/button/auto_spin_button.dart';
import 'package:fortune_game/component/button/bet_button.dart';
import 'package:fortune_game/component/button/ex_bg_button.dart';
import 'package:fortune_game/component/button/ex_button.dart';
import 'package:fortune_game/component/button/quick_start_button.dart';
import 'package:fortune_game/component/button/setting_button.dart';
import 'package:fortune_game/component/ex_animation/ex_animation.dart';
import 'package:fortune_game/component/ex_animation/ex_tag.dart';
import 'package:fortune_game/component/marquee/spin_button.dart';
import 'package:fortune_game/component/roller/slot_machine_blocks_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_magnification_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/component/button/spin_button.dart';
import 'package:fortune_game/component/roller/win_magnification_block.dart';
import 'package:fortune_game/component/sprite_number_component/sprite_number_component.dart';
import 'package:fortune_game/component/system_alert/big_win.dart';
import 'package:fortune_game/component/system_alert/frame_win_bg.dart';
import 'package:fortune_game/component/system_alert/line_hint.dart';
import 'package:fortune_game/component/system_alert/mega_win.dart';
import 'package:fortune_game/component/system_alert/super_win.dart';
import 'package:fortune_game/component/system_alert/system_alert.dart';
import 'package:fortune_game/component/system_alert/system_explanation.dart';
import 'package:fortune_game/models/betting_result_model.dart';
import 'package:fortune_game/symbol/calculate/calculate_win.dart';
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

  late ClipComponent clipComponentFirst;
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

  //是否是连续转动
  bool isContinuousSpinning = false;

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
      if(rollerState == RollerState.stopped && !isContinuousSpinning){
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

    // frameWinBg = FrameWinBg(score: "200", bettingOdds: bettingAmount);
    // add(frameWinBg);
    // lineHint = LineHint(block: '', bettingOdds: '1', lines: '1', score: '999');
    // add(lineHint);


    super.onLoad();
  }

  //初始化
  Future<void> init() async {
    exBgSpriteComponent = ExBgButton(onTap: (value){
      Map map = value;
      if(map['switchSprite']){
        Parameter.isOpenExMode = true;
        add(exTag);
        add(ExAnimation());
        Future.delayed(const Duration(seconds: 1), () {
          changeExMode();
        });
      }else{
        Parameter.isOpenExMode = false;
        if(exTag.isMounted){
          remove(exTag);
          slotMachineMagnificationRoller.revertRoller();
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

    //初始化EffectController
    // slotMachineBlocksRollerFirstEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.firstRollerRepeatTimes);
    // slotMachineBlocksRollerSecondEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.secondRollerRepeatTimes);
    // slotMachineBlocksRollerThirdEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.thirdRollerRepeatTimes);
    // slotMachineMagnificationRollerEffectController = RepeatedEffectController(LinearEffectController(0.15), Parameter.magnificationRollerRepeatTimes);

    // slotMachineBlocksRollerFirstEffectController = RepeatedEffectController(LinearEffectController(0.15), 9);
    // slotMachineBlocksRollerSecondEffectController = RepeatedEffectController(LinearEffectController(0.15), 12);
    // slotMachineBlocksRollerThirdEffectController = RepeatedEffectController(LinearEffectController(0.15), 15);
    // slotMachineMagnificationRollerEffectController = RepeatedEffectController(LinearEffectController(0.15), 18);

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

    clipComponentFirst = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(-135,-100), size: Vector2(143, 290), children: firstComponents);
    clipComponentSecond = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(7,-100), size: Vector2(143, 290), children: secondComponents);
    clipComponentThird = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(149,-100), size: Vector2(143, 290), children: thirdComponents);

    //倍率行
    addBlocks(magnification, BlockType.magnification);
    slotMachineMagnificationRoller = SlotMachineMagnificationRoller(position: Vector2(200,-100), blocksRoller: magnification, blocksPositions: SymbolBlocks().magnificationPositions);
    magnificationComponents = [slotMachineMagnificationRoller];

    clipComponentMagnification = ClipComponent.rectangle(anchor: Anchor.topRight,position: Vector2(275,-100), size: Vector2(130, 300), children: magnificationComponents);


    //连线
    winFirstRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_1.png'),
        size: Vector2(460,426),
        position: Vector2(-290,-260)
    );

    winSecondRowLine = SpriteComponent(
        sprite: await Sprite.load('lines/line_2.png'),
        size: Vector2(460,426),
        position: Vector2(-290,-20)
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
    winLines = [winFirstRowLine,winSecondRowLine,winThirdRowLine,winForthRowLine,windFifthRowLine];

    systemAlert = SystemAlert(onTap: (){
      remove(systemAlert);
    });

    autoSpinButton = AutoSpinButton(isQuickSpinning: isQuickSpinning,onTap: (){
      print('连续转动');
      if(isContinuousSpinning){
        isContinuousSpinning = false;
        stopSpinning(RollerType.firstRoller);
        stopSpinning(RollerType.secondRoller);
        stopSpinning(RollerType.thirdRoller);
        stopSpinning(RollerType.magnificationRoller);
      }else{
        isContinuousSpinning = true;
        startSpinning();
      }
    });
    exTag = ExTag();
    systemExplanation = SystemExplanation();

  }

  @override
  void update(double dt) {
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
        // final dio = Dio();
        // final response = await dio.post('https://fortune-game-server.zeabur.app/bet/normal-game');
        // BettingResultModel bettingResultModel = BettingResultModel.fromJson(response.data);
        // print(bettingResultModel);

        roundWinPoints = '0';
        firstRollerSpinning = true;
        secondRollerSpinning = true;
        thirdRollerSpinning = true;
        magnificationRollerSpinning = true;
        slotMachineMagnificationRoller.defaultBlocks = [];
        resetRoundWinComponents();
        print('单次转动');
        print('开始转动');
        //移除所有winLine
        for(int i = 0;i<winLines.length;i++){
          if(winLines[i].isMounted){
            remove(winLines[i]);
          }
        }
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
      isContinuousSpinning = false;
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
        slotMachineMagnificationRoller.position = Vector2(200,-80);
        //回弹效果
        MoveEffect moveEffect = MoveEffect.to(Vector2(slotMachineMagnificationRoller.position.x,slotMachineMagnificationRoller.position.y- 20),EffectController(duration: 0.35,curve: Curves.easeInOut),onComplete: (){
          slotMachineMagnificationRoller.removeAll(slotMachineMagnificationRoller.children.whereType<Effect>());
          firstMoveEffect.reset();
          secondMoveEffect.reset();
          thirdMoveEffect.reset();
          magnificationMoveEffect.reset();
          checkWin();
          if(isContinuousSpinning){
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

  //检查是否获胜
  void checkWin(){

    for(int i =2;i<blocksRollerFirst.length;i++){
      List<SlotMachineRollerBlock> slotMachineFirstRollerBlocks = slotMachineBlocksFirstRoller.blocksRoller;
      List<SlotMachineRollerBlock> slotMachineSecondRollerBlocks = slotMachineBlocksSecondRoller.blocksRoller;
      List<SlotMachineRollerBlock> slotMachineThirdRollerBlocks = slotMachineBlocksThirdRoller.blocksRoller;
      List<SlotMachineRollerBlock> slotMachineMagnificationRollerBlocks = slotMachineMagnificationRoller.blocksRoller;

      //判断横向是否有连线
      for(int i = 2;i<blocksRollerFirst.length;i++){
        String firstBlockImage = slotMachineFirstRollerBlocks[i].image;
        String secondBlockImage = slotMachineSecondRollerBlocks[i].image;
        String thirdBlockImage = slotMachineThirdRollerBlocks[i].image;
        String magnificationBlockImage = slotMachineMagnificationRollerBlocks[i].image;
        print('----$i----');
        print(firstBlockImage);
        print(secondBlockImage);
        print(thirdBlockImage);
        if(firstBlockImage == secondBlockImage && firstBlockImage == thirdBlockImage){
          print('----横向有相同----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
        //特殊老虎方块有一个
        if(firstBlockImage == secondBlockImage && 'blocks/symbol_wild.png' == thirdBlockImage){
          print('----横向有相同(特殊老虎方块一个)----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
        if(secondBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == firstBlockImage ){
          print('----横向有相同(特殊老虎方块一个)----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
        if(firstBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == secondBlockImage){
          print('----横向有相同(特殊老虎方块一个)----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
        //特殊老虎方块有两个
        if(firstBlockImage == secondBlockImage  && 'blocks/symbol_wild.png' == firstBlockImage){
          print('----横向有相同(特殊老虎方块两块)----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
        if(firstBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == firstBlockImage){
          print('----横向有相同(特殊老虎方块两块)----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
        if(secondBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == secondBlockImage){
          print('----横向有相同(特殊老虎方块两块)----');
          if(i == 2){
            add(winFirstRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else if(i == 3){
            add(winSecondRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }else{
            add(winThirdRowLine);
            isWin = true;
            blocksRemoveMask(LineConnectionType.horizontal,index: i);
            getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
          }
        }
      }

      //判断斜向是否有连线
      String firstSecondBlockImage = slotMachineFirstRollerBlocks[2].image;
      String firstForthBlockImage = slotMachineFirstRollerBlocks[4].image;
      String secondCenterBlockImage = slotMachineSecondRollerBlocks[3].image;
      String thirdSecondBlockImage = slotMachineThirdRollerBlocks[2].image;
      String thirdForthBlockImage = slotMachineThirdRollerBlocks[4].image;
      String secondMagnificationBlockImage =slotMachineMagnificationRollerBlocks[2].image;
      String thirdMagnificationBlockImage =slotMachineMagnificationRollerBlocks[4].image;

      if(firstSecondBlockImage == secondCenterBlockImage && firstSecondBlockImage == thirdForthBlockImage){
        print('----左上右下斜向有相同----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(firstForthBlockImage == secondCenterBlockImage && firstForthBlockImage == thirdSecondBlockImage){
        print('----左下右上斜向有相同----');
        add(windFifthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftDownRightUp);
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, secondMagnificationBlockImage, bettingAmount));

      }
      //特殊老虎方块有一个
      if(firstSecondBlockImage == secondCenterBlockImage && 'blocks/symbol_wild.png' == thirdForthBlockImage){
        print('----左上右下斜向有相同(特殊老虎方块一个)----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(firstSecondBlockImage == thirdForthBlockImage && 'blocks/symbol_wild.png' == secondCenterBlockImage){
        print('----左上右下斜向有相同(特殊老虎方块一个)----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(secondCenterBlockImage == thirdForthBlockImage && 'blocks/symbol_wild.png' == firstSecondBlockImage){
        print('----左上右下斜向有相同(特殊老虎方块一个)----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(firstForthBlockImage == secondCenterBlockImage && 'blocks/symbol_wild.png'  == thirdSecondBlockImage){
        print('----左下右上斜向有相同(特殊老虎方块一个)----');
        add(windFifthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftDownRightUp);
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(firstForthBlockImage == thirdSecondBlockImage && 'blocks/symbol_wild.png' == secondCenterBlockImage){
        print('----左下右上斜向有相同(特殊老虎方块一个)----');
        add(windFifthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftDownRightUp);
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(secondCenterBlockImage == thirdSecondBlockImage && 'blocks/symbol_wild.png' == firstForthBlockImage){
        print('----左下右上斜向有相同(特殊老虎方块一个)----');
        add(windFifthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftDownRightUp);
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      //特殊老虎方块有两个
      if(firstSecondBlockImage == secondCenterBlockImage && firstSecondBlockImage == 'blocks/symbol_wild.png'){
        print('----左上右下斜向有相同(特殊老虎方块两块)----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(secondCenterBlockImage == thirdForthBlockImage && secondCenterBlockImage == 'blocks/symbol_wild.png'){
        print('----左上右下斜向有相同(特殊老虎方块两块)----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));

      }
      if(firstSecondBlockImage == thirdForthBlockImage && firstSecondBlockImage == 'blocks/symbol_wild.png'){
        print('----左上右下斜向有相同(特殊老虎方块两块)----');
        add(winForthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftUpRightDown);
        getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(firstForthBlockImage == secondCenterBlockImage && firstForthBlockImage == 'blocks/symbol_wild.png'){
        print('----左下右上斜向有相同(特殊老虎方块两块)----');
        add(windFifthRowLine);
        isWin = true;
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(secondCenterBlockImage == thirdSecondBlockImage && secondCenterBlockImage == 'blocks/symbol_wild.png'){
        print('----左下右上斜向有相同(特殊老虎方块两块)----');
        add(windFifthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftDownRightUp);
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
      if(firstForthBlockImage == thirdSecondBlockImage && firstForthBlockImage == 'blocks/symbol_wild.png'){
        print('----左下右上斜向有相同(特殊老虎方块两块)----');
        add(windFifthRowLine);
        isWin = true;
        blocksRemoveMask(LineConnectionType.leftDownRightUp);
        getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
      }
    }

    if(!isWin){
      //没有获胜，扣除投注金额
      print('没有获胜');
      balance = (int.parse(balance) - int.parse(bettingAmount)).toString();
      print('balance:$balance');
      remove(balanceTextComponent);
      balanceTextComponent = TextComponent(
        anchor: Anchor.topCenter,
        text: 'Balance  $balance',
        scale: Vector2(0.8,0.8),
        position: Vector2(0, 343),
      );
      add(balanceTextComponent);
      isCanSpin = true;
    }else{
      //获胜，加上奖励金额
      print('获胜');
      remove(balanceTextComponent);
      int result = 0;
      for(int i = 0;i<getPointsList.length;i++){
        result = result+getPointsList[i];
      }
      roundWinPoints = result.toString();
      showWinHint(roundWinPoints);
      resetRoundWinComponents();
      balance = (int.parse(balance) + result).toString();
      print('balance:$balance');
      balanceTextComponent = TextComponent(
        anchor: Anchor.topCenter,
        text: 'Balance  $balance',
        scale: Vector2(0.8,0.8),
        position: Vector2(0, 343),
      );
      add(balanceTextComponent);
    }
  }

  Future<void> blocksAddMask()async {
    print(slotMachineBlocksFirstRoller.blocksRoller[0]);
    if(!slotMachineBlocksFirstRoller.blocksRoller[0].rectangleComponent.isMounted){
      for(int i = 0;i<slotMachineBlocksFirstRoller.blocksRoller.length;i++){
        SlotMachineRollerBlock slotMachineRollerFirstBlock = slotMachineBlocksFirstRoller.blocksRoller[i];
        SlotMachineRollerBlock slotMachineRollerSecondBlock = slotMachineBlocksSecondRoller.blocksRoller[i];
        SlotMachineRollerBlock slotMachineRollerThirdBlock = slotMachineBlocksThirdRoller.blocksRoller[i];
        SlotMachineRollerBlock slotMachineRollerMagnificationBlock = slotMachineMagnificationRoller.blocksRoller[i];
        slotMachineRollerFirstBlock.addMask();
        slotMachineRollerSecondBlock.addMask();
        slotMachineRollerThirdBlock.addMask();
        slotMachineRollerMagnificationBlock.addMask();
      }
    }
  }

  void blocksRemoveMask(LineConnectionType lineConnectionType,{int? index} ){
    blocksAddMask();
    //横向连线
    if(lineConnectionType == LineConnectionType.horizontal){
      for(int i = 0;i<slotMachineBlocksFirstRoller.blocksRoller.length;i++){
        if(i == index){
          SlotMachineRollerBlock slotMachineRollerFirstBlock = slotMachineBlocksFirstRoller.blocksRoller[i];
          SlotMachineRollerBlock slotMachineRollerSecondBlock = slotMachineBlocksSecondRoller.blocksRoller[i];
          SlotMachineRollerBlock slotMachineRollerThirdBlock = slotMachineBlocksThirdRoller.blocksRoller[i];
          slotMachineRollerFirstBlock.removeMask();
          slotMachineRollerSecondBlock.removeMask();
          slotMachineRollerThirdBlock.removeMask();
        }
      }
    }else{
      //左上右下斜向连线
      if(lineConnectionType == LineConnectionType.leftUpRightDown){
        for(int i = 0;i<slotMachineBlocksFirstRoller.blocksRoller.length;i++){
          if(i==2){
            SlotMachineRollerBlock slotMachineRollerFirstBlock = slotMachineBlocksFirstRoller.blocksRoller[i];
            slotMachineRollerFirstBlock.removeMask();
          }
        }
        for(int i = 0;i<slotMachineBlocksSecondRoller.blocksRoller.length;i++){
          if(i==3){
            SlotMachineRollerBlock slotMachineRollerSecondBlock = slotMachineBlocksSecondRoller.blocksRoller[i];
            slotMachineRollerSecondBlock.removeMask();
          }
        }
        for(int i = 0;i<slotMachineBlocksThirdRoller.blocksRoller.length;i++){
          if(i==4){
            SlotMachineRollerBlock slotMachineRollerThirdBlock = slotMachineBlocksThirdRoller.blocksRoller[i];
            slotMachineRollerThirdBlock.removeMask();
          }
        }
      }else{
        //左下右上斜向连线
        for(int i = 0;i<slotMachineBlocksFirstRoller.blocksRoller.length;i++){
          if(i==4){
            SlotMachineRollerBlock slotMachineRollerFirstBlock = slotMachineBlocksFirstRoller.blocksRoller[i];
            slotMachineRollerFirstBlock.removeMask();
          }
        }
        for(int i = 0;i<slotMachineBlocksSecondRoller.blocksRoller.length;i++){
          if(i==3){
            SlotMachineRollerBlock slotMachineRollerSecondBlock = slotMachineBlocksSecondRoller.blocksRoller[i];
            slotMachineRollerSecondBlock.removeMask();
          }
        }
        for(int i = 0;i<slotMachineBlocksThirdRoller.blocksRoller.length;i++){
          if(i==2){
            SlotMachineRollerBlock slotMachineRollerThirdBlock = slotMachineBlocksThirdRoller.blocksRoller[i];
            slotMachineRollerThirdBlock.removeMask();
          }
        }
      }
    }
    SlotMachineRollerBlock slotMachineRollerMagnificationBlock = slotMachineMagnificationRoller.blocksRoller[3];
    slotMachineRollerMagnificationBlock.removeMask();
  }

  //显示获胜提示
  void showWinHint(String score){
    frameWinBg = FrameWinBg(score: roundWinPoints, bettingOdds: bettingAmount);
    lineHint = LineHint(block: '', bettingOdds: bettingAmount, lines: '1', score: roundWinPoints);
    add(frameWinBg);
    add(lineHint);
    showMagnificationBlock();
    Future.delayed(const Duration(seconds: 3), () {
      remove(frameWinBg);
      remove(lineHint);
      bigWin = BigWin(score: score);
      add(bigWin);
      Future.delayed(const Duration(seconds: 3), () {
        remove(bigWin);
        megaWin = MegaWin(score: score);
        add(megaWin);
        Future.delayed(const Duration(seconds: 3), () {
          remove(megaWin);
          superWin = SuperWin(score: score);
          add(superWin);
          Future.delayed(const Duration(seconds: 3), () {
            remove(superWin);
            isCanSpin = true;
          });
        });
      });
    });
  }

  void changeExMode(){
    slotMachineMagnificationRoller.changeExMode();
  }

  void showMagnificationBlock(){
    SlotMachineRollerBlock slotMachineRollerMagnificationBlock = slotMachineMagnificationRoller.blocksRoller[3];
    winSlotMachineRollerMagnificationBlock = WinMagnificationBlock(image: slotMachineRollerMagnificationBlock.image);
    add(winSlotMachineRollerMagnificationBlock);
    Future.delayed(const Duration(seconds: 1), () {
      EffectController effectController = EffectController(duration: 0.7, curve: Curves.linear);
      MoveEffect moveEffect = MoveEffect.to(Vector2(winSlotMachineRollerMagnificationBlock.position.x-270, winSlotMachineRollerMagnificationBlock.position.y),
          effectController,onComplete: (){
            winSlotMachineRollerMagnificationBlock.removeAll(exBgSpriteComponent.children.whereType<Effect>());
            remove(winSlotMachineRollerMagnificationBlock);
          });
      winSlotMachineRollerMagnificationBlock.add(moveEffect);
    });
  }

  void resetRoundWinComponents(){
    remove(roundWinPointsTextComponent);
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
    add(roundWinPointsTextComponent);
  }

  //测试连线后遮罩效果
  void test(){
    List list1 = slotMachineBlocksFirstRoller.blocksRoller;
    for(int i = 0;i<list1.length;i++){
      SlotMachineRollerBlock block = list1[i];
      print(block);
      block.add(RectangleComponent(
        position:Vector2(0,0),
          size: Vector2(174,100), paint: Paint()..color = Colors.black.withOpacity(0.3)));
    }

    List list2 = slotMachineBlocksSecondRoller.blocksRoller;
    for(int i =0;i<list2.length;i++){
      SlotMachineRollerBlock block = list2[i];
      block.add(RectangleComponent(
          position:Vector2(0,0),
          size: Vector2(174,100), paint: Paint()..color = Colors.black.withOpacity(0.3)));
    }

    List list3= slotMachineBlocksThirdRoller.blocksRoller;
    for(int i =0;i<list3.length;i++){
      SlotMachineRollerBlock block = list3[i];
      block.add(RectangleComponent(
          position:Vector2(0,0),
          size: Vector2(174,100), paint: Paint()..color = Colors.black.withOpacity(0.3)));
    }
  }

}
