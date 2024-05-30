
import 'package:flame/components.dart';

class SymbolBlocks {
  List<String> blocksImageList = [
    'blocks/symbol_00.png',
    'blocks/symbol_01.png',
    'blocks/symbol_02.png',
    'blocks/symbol_03.png',
    'blocks/symbol_04.png',
    'blocks/symbol_05.png',
    'blocks/symbol_06.png',
    'blocks/symbol_07.png',
  ];

  List<String> magnificationImageList = [
    'magnifications/magnification_1x.png',
    'magnifications/magnification_2x.png',
    'magnifications/magnification_3x.png',
    'magnifications/magnification_5x.png',
    'magnifications/magnification_10x.png',
    'magnifications/magnification_15x.png',
  ];

  List<String> marqueeText = [
    'marquees/marquee_text_1.png',
    'marquees/marquee_text_2.png',
    'marquees/marquee_text_3.png',
    'marquees/marquee_text_4.png'
  ];

  List<Vector2> blocksPositions = [
    //未来显示
    Vector2(343,-100),
    Vector2(343,0),
    //当前显示
    Vector2(343,100),
    Vector2(343,200),
    Vector2(343,300),
  ];

  List<Vector2> magnificationPositions = [
    //未来显示
    Vector2(-136,-100),
    Vector2(-136,0),
    //当前显示
    Vector2(-136,100),
    Vector2(-136,200),
    Vector2(-136,300),
  ];
}
