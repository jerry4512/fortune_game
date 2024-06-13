

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

}
