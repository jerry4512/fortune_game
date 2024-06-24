
import 'package:flame/components.dart';

class SymbolBlocks {
  List<String> blocksImageList = [
    'blocks/symbol_h1.png',
    'blocks/symbol_h2.png',
    'blocks/symbol_h3.png',
    'blocks/symbol_n1.png',
    'blocks/symbol_n2.png',
    'blocks/symbol_n3.png',
    'blocks/symbol_n4.png',
    'blocks/symbol_wild.png',
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
    Vector2(343,-90),
    Vector2(343,-10),
    //当前显示
    Vector2(343,90),
    Vector2(343,190),
    Vector2(343,290),
  ];

  List<Vector2> magnificationPositions = [
    //未来显示
    Vector2(-136,-93),
    Vector2(-136,7),
    //当前显示
    Vector2(-136,107),
    Vector2(-136,207),
    Vector2(-136,307),
  ];

  Map bettingOddsMap = {
    'blocks/symbol_h1.png' : 20,
    'blocks/symbol_h2.png' : 15,
    'blocks/symbol_h3.png' : 12,
    'blocks/symbol_n1.png' : 10,
    'blocks/symbol_n2.png' : 8,
    'blocks/symbol_n3.png' : 5,
    'blocks/symbol_n4.png' : 2,
    'blocks/symbol_wild.png' : 25,
  };

  Map specialRateMap = {
    'magnifications/magnification_1x.png' : 1,
    'magnifications/magnification_2x.png' : 2,
    'magnifications/magnification_3x.png' : 3,
    'magnifications/magnification_5x.png' : 5,
    'magnifications/magnification_10x.png' : 10,
    'magnifications/magnification_15x.png' : 15,
  };


  List winLineHintBlocks = [
    'win_line_hint_blocks/line_hint_h1.png',
    'win_line_hint_blocks/line_hint_h2.png',
    'win_line_hint_blocks/line_hint_h3.png',
    'win_line_hint_blocks/line_hint_n1.png',
    'win_line_hint_blocks/line_hint_n2.png',
    'win_line_hint_blocks/line_hint_n3.png',
    'win_line_hint_blocks/line_hint_n4.png',
    'win_line_hint_blocks/line_hint_wild.png',
  ];

  List winLineHintMagnifications = [
    'win_line_hint_blocks/line_hint_1x.png',
    'win_line_hint_blocks/line_hint_2x.png',
    'win_line_hint_blocks/line_hint_3x.png',
    'win_line_hint_blocks/line_hint_5x.png',
    'win_line_hint_blocks/line_hint_10x.png',
    'win_line_hint_blocks/line_hint_15x.png',
  ];

}
