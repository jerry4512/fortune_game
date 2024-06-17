

import 'dart:js_interop';

import 'package:fortune_game/component/roller/slot_machine_blocks_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_magnification_roller.dart';
import 'package:fortune_game/component/roller/slot_machine_roller_block.dart';
import 'package:fortune_game/symbol/enum.dart';
import 'package:fortune_game/symbol/symbol_blocks.dart';

class CalculateWin {

  static List<String> winBlock = [];

  static List<String> winMagnificationList = [];

  int getPoints(String firstBlockImage, String secondBlockImage, String thirdBlockImage, String magnificationBlockImage,  String bettingAmount){
    int bettingOdds = 0;
    int points = 0;
    int specialRate = SymbolBlocks().specialRateMap[magnificationBlockImage];
    winMagnificationList = [magnificationBlockImage];
    //三个相同
    if(firstBlockImage == secondBlockImage && secondBlockImage == thirdBlockImage){
      switch(firstBlockImage){
        case 'blocks/symbol_h1.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_h2.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_h3.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_n1.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_n2.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_n3.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_n4.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      case 'blocks/symbol_wild.png':
          bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
          break;
      }
    }
    //一个是Wild方快
    if(firstBlockImage == 'blocks/symbol_wild.png'){
      bettingOdds = SymbolBlocks().bettingOddsMap[secondBlockImage];
    }
    if(secondBlockImage == 'blocks/symbol_wild.png'){
      bettingOdds = SymbolBlocks().bettingOddsMap[thirdBlockImage];
    }
    if(thirdBlockImage == 'blocks/symbol_wild.png'){
      bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
    }
    //两个是Wild方快
    if(firstBlockImage == 'blocks/symbol_wild.png' && secondBlockImage == 'blocks/symbol_wild.png'){
      bettingOdds = SymbolBlocks().bettingOddsMap[thirdBlockImage];
    }
    if(secondBlockImage == 'blocks/symbol_wild.png' && thirdBlockImage == 'blocks/symbol_wild.png'){
      bettingOdds = SymbolBlocks().bettingOddsMap[firstBlockImage];
    }
    if(firstBlockImage == 'blocks/symbol_wild.png' && thirdBlockImage == 'blocks/symbol_wild.png'){
      bettingOdds = SymbolBlocks().bettingOddsMap[secondBlockImage];
    }
    points = calculateWinPoints(bettingOdds, int.parse(bettingAmount), specialRate);
    return points;
  }

  //计算赢得的奖金
  //中獎贏分 = (賠率/5) x 押注額 x 特殊轉輪倍率
  int calculateWinPoints(int bettingOdds, int bettingAmount, int specialRate){
    print('----中獎贏分----');
    print('赔率： $bettingOdds' );
    print('押注額： $bettingAmount' );
    print('倍率： $specialRate' );
    print('$bettingOdds/5 x${bettingAmount}x$specialRate' );
    double result1 = (bettingOdds/5);
    double result = result1* bettingAmount * specialRate;
    print('中獎贏分： $result');
    print('中獎贏分：${result.toInt()}');
    return result.toInt();
  }

  //检查是否获胜
  // Map checkWin(List<SlotMachineRollerBlock> blocksRollerFirst,SlotMachineBlocksRoller slotMachineBlocksFirstRoller,SlotMachineBlocksRoller slotMachineBlocksSecondRoller,SlotMachineBlocksRoller slotMachineBlocksThirdRoller,SlotMachineMagnificationRoller slotMachineMagnificationRoller,
  //     String bettingAmount){
  //   List<LineConnectionType> resultList = [];
  //   List getPointsList = [];
  //   for(int i =2;i<blocksRollerFirst.length;i++){
  //     List<SlotMachineRollerBlock> slotMachineFirstRollerBlocks = slotMachineBlocksFirstRoller.blocksRoller;
  //     List<SlotMachineRollerBlock> slotMachineSecondRollerBlocks = slotMachineBlocksSecondRoller.blocksRoller;
  //     List<SlotMachineRollerBlock> slotMachineThirdRollerBlocks = slotMachineBlocksThirdRoller.blocksRoller;
  //     List<SlotMachineRollerBlock> slotMachineMagnificationRollerBlocks = slotMachineMagnificationRoller.blocksRoller;
  //
  //     //判断横向是否有连线
  //     for(int i = 2;i<blocksRollerFirst.length;i++){
  //       String firstBlockImage = slotMachineFirstRollerBlocks[i].image;
  //       String secondBlockImage = slotMachineSecondRollerBlocks[i].image;
  //       String thirdBlockImage = slotMachineThirdRollerBlocks[i].image;
  //       String magnificationBlockImage = slotMachineMagnificationRollerBlocks[i].image;
  //       print('----$i----');
  //       print(firstBlockImage);
  //       print(secondBlockImage);
  //       print(thirdBlockImage);
  //       if(firstBlockImage == secondBlockImage && firstBlockImage == thirdBlockImage){
  //         print('----横向有相同----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //       //特殊老虎方块有一个
  //       if(firstBlockImage == secondBlockImage && 'blocks/symbol_wild.png' == thirdBlockImage){
  //         print('----横向有相同(特殊老虎方块一个)----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //       if(secondBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == firstBlockImage ){
  //         print('----横向有相同(特殊老虎方块一个)----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //       if(firstBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == secondBlockImage){
  //         print('----横向有相同(特殊老虎方块一个)----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalCenter);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //       //特殊老虎方块有两个
  //       if(firstBlockImage == secondBlockImage  && 'blocks/symbol_wild.png' == firstBlockImage){
  //         print('----横向有相同(特殊老虎方块两块)----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalCenter);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //       if(firstBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == firstBlockImage){
  //         print('----横向有相同(特殊老虎方块两块)----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalCenter);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //       if(secondBlockImage == thirdBlockImage  && 'blocks/symbol_wild.png' == secondBlockImage){
  //         print('----横向有相同(特殊老虎方块两块)----');
  //         if(i == 2){
  //           resultList.add(LineConnectionType.horizontalTop);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else if(i == 3){
  //           resultList.add(LineConnectionType.horizontalCenter);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }else{
  //           resultList.add(LineConnectionType.horizontalBottom);
  //           getPointsList.add(CalculateWin().getPoints(firstBlockImage, secondBlockImage, thirdBlockImage, magnificationBlockImage, bettingAmount));
  //         }
  //       }
  //     }
  //
  //     //判断斜向是否有连线
  //     String firstSecondBlockImage = slotMachineFirstRollerBlocks[2].image;
  //     String firstForthBlockImage = slotMachineFirstRollerBlocks[4].image;
  //     String secondCenterBlockImage = slotMachineSecondRollerBlocks[3].image;
  //     String thirdSecondBlockImage = slotMachineThirdRollerBlocks[2].image;
  //     String thirdForthBlockImage = slotMachineThirdRollerBlocks[4].image;
  //     String secondMagnificationBlockImage =slotMachineMagnificationRollerBlocks[2].image;
  //     String thirdMagnificationBlockImage =slotMachineMagnificationRollerBlocks[4].image;
  //
  //     if(firstSecondBlockImage == secondCenterBlockImage && firstSecondBlockImage == thirdForthBlockImage){
  //       print('----左上右下斜向有相同----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(firstForthBlockImage == secondCenterBlockImage && firstForthBlockImage == thirdSecondBlockImage){
  //       print('----左下右上斜向有相同----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, secondMagnificationBlockImage, bettingAmount));
  //
  //     }
  //     //特殊老虎方块有一个
  //     if(firstSecondBlockImage == secondCenterBlockImage && 'blocks/symbol_wild.png' == thirdForthBlockImage){
  //       print('----左上右下斜向有相同(特殊老虎方块一个)----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(firstSecondBlockImage == thirdForthBlockImage && 'blocks/symbol_wild.png' == secondCenterBlockImage){
  //       print('----左上右下斜向有相同(特殊老虎方块一个)----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(secondCenterBlockImage == thirdForthBlockImage && 'blocks/symbol_wild.png' == firstSecondBlockImage){
  //       print('----左上右下斜向有相同(特殊老虎方块一个)----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(firstForthBlockImage == secondCenterBlockImage && 'blocks/symbol_wild.png'  == thirdSecondBlockImage){
  //       print('----左下右上斜向有相同(特殊老虎方块一个)----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(firstForthBlockImage == thirdSecondBlockImage && 'blocks/symbol_wild.png' == secondCenterBlockImage){
  //       print('----左下右上斜向有相同(特殊老虎方块一个)----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(secondCenterBlockImage == thirdSecondBlockImage && 'blocks/symbol_wild.png' == firstForthBlockImage){
  //       print('----左下右上斜向有相同(特殊老虎方块一个)----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     //特殊老虎方块有两个
  //     if(firstSecondBlockImage == secondCenterBlockImage && firstSecondBlockImage == 'blocks/symbol_wild.png'){
  //       print('----左上右下斜向有相同(特殊老虎方块两块)----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(secondCenterBlockImage == thirdForthBlockImage && secondCenterBlockImage == 'blocks/symbol_wild.png'){
  //       print('----左上右下斜向有相同(特殊老虎方块两块)----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //
  //     }
  //     if(firstSecondBlockImage == thirdForthBlockImage && firstSecondBlockImage == 'blocks/symbol_wild.png'){
  //       print('----左上右下斜向有相同(特殊老虎方块两块)----');
  //       resultList.add(LineConnectionType.leftUpRightDown);
  //       getPointsList.add(CalculateWin().getPoints(firstSecondBlockImage, secondCenterBlockImage, thirdForthBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(firstForthBlockImage == secondCenterBlockImage && firstForthBlockImage == 'blocks/symbol_wild.png'){
  //       print('----左下右上斜向有相同(特殊老虎方块两块)----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(secondCenterBlockImage == thirdSecondBlockImage && secondCenterBlockImage == 'blocks/symbol_wild.png'){
  //       print('----左下右上斜向有相同(特殊老虎方块两块)----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //     if(firstForthBlockImage == thirdSecondBlockImage && firstForthBlockImage == 'blocks/symbol_wild.png'){
  //       print('----左下右上斜向有相同(特殊老虎方块两块)----');
  //       resultList.add(LineConnectionType.leftDownRightUp);
  //       getPointsList.add(CalculateWin().getPoints(firstForthBlockImage, secondCenterBlockImage, thirdSecondBlockImage, thirdMagnificationBlockImage, bettingAmount));
  //     }
  //   }
  //   Map map = {
  //     'resultList':resultList,
  //     'getPointsList': getPointsList
  //   };
  //   return map;
  //
  // }

}
