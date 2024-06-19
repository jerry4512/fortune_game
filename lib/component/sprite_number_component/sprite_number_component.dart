import 'dart:developer';
import 'package:flame/components.dart';

/// 這是一個用數字圖 png 來拚出來的 2D 數字元件，目前只支援顯示正整數。
/// 目前支援使用檔名: 0.png ~ 9.png 來製成元件，這些圖片都必須要有。
/// fixedLength 指定位數長度，不足長的 int 在高位數會以 0 顯示來補足長度。
/// fixedLength 為 0 時則為不指定長度。
class SpriteNumberComponent extends PositionComponent {
  SpriteNumberComponent({
    required String srcDirPath,
    this.initNum,
    this.fixedDigitLength = 0,
    this.fixedDecimalPlaceLength = -1,
    this.enableThousandsSeparator = false,
    this.fileExt = 'png',
    super.position,
    super.scale,
    super.anchor,
    super.priority,
    super.key,
    this.onTickComplete,
  }) : _srcDirPath = srcDirPath.endsWith('/') ? srcDirPath : '$srcDirPath/';

  /// The source images dir path.
  final String _srcDirPath;

  /// This number should be set after onLoad() finished.
  final num? initNum;

  /// 圖片副檔名，預設 png.
  final String fileExt;

  /// 指定固定整數部分長度。
  final int fixedDigitLength;

  /// 指定固定小數部分長度，預設 -1 代表動態長度.
  final int fixedDecimalPlaceLength;

  // 是否使用每千位數逗號分隔標示，預設 false。
  final bool enableThousandsSeparator;

  // 當前顯示數字為何?
  double _currentNumber = 0;

  // onLoad 時預載直接 cache 在這個元件內，改變數字時即可直接使用。
  // 按照順序分別就是 0 ~ 9 的圖片 sprite.
  final List<Sprite> _numberSprites = [];

  // 分隔號圖片，可以沒有。
  Sprite? _commaSprite;

  // 小數點圖片，可以沒有。
  Sprite? _decimalPointSprite;

  // 所有可以用來顯示用的 SpriteComponent, 有 N = 32 個，給所有數字顯示，包含逗點與小數點。
  // 取用順序邏輯為從最低位到最高位。
  final List<SpriteComponent> _spriteComponents = [];

  // 是否初始化成功? 在提供圖片不合法的狀況下將會初始化失敗。
  bool _initializeSuccess = false;

  // 當前正在跳動至某個目標數字。
  double _tickToTarget = 0;

  // 開始跳動時，當時的數字是多少。
  double _startTickingNumber = 0;

  // 當前跳動數字設定用多久時間。為 null 時，代表沒有在跳動。
  Duration? _tickDuration;

  // 累積數字跳動時間。
  double _tickAccumulatedTime = 0;

  // 累積計算跳動間隔時間。
  double _tickRateAccumulatedTime = 0;

  // 跳動間隔時間。
  static const double _tickRateTime = 0.025;

  // 當完成 tick 時會被呼叫。
  final Function()? onTickComplete;

  @override
  Future<void> onLoad() async {
    // 嘗試載入 comma， 允許無檔案的狀況。
    try {
      _commaSprite = await Sprite.load('${_srcDirPath}comma.$fileExt');
    } catch (_) {
      log('[No comma file]: $_srcDirPath');
    }

    // 嘗試載入 decimal point， 允許無檔案的狀況。
    try {
      _decimalPointSprite = await Sprite.load('${_srcDirPath}dot.$fileExt');
    } catch (_) {
      log('[No comma file]: $_srcDirPath');
    }

    try {
      // load all number sprites.
      for (int i = 0; i <= 9; ++i) {
        _numberSprites.add(await Sprite.load('$_srcDirPath$i.$fileExt'));
      }

      for (int i = 0; i < 32; ++i) {
        //注意這邊我們強制使用 Anchor.bottomRight, 真正的錨點計算會需要手動在設定數字後處理。
        SpriteComponent digit = SpriteComponent(sprite: _numberSprites[0], anchor: Anchor.bottomRight);
        _spriteComponents.add(digit);
        add(digit);
      }

      _initializeSuccess = true;

      //首先設定一次數字。
      if (initNum != null) {
        set(initNum!);
      } else {
        set(0);
      }

      // log('[SpriteNumberComponent Load Success]');
    } catch (e) {
      log('[SpriteNumberComponent Load Failed!]: $_srcDirPath | $e');
    }

    super.onLoad();
  }

  @override
  void update(double dt) {
    // Check and try tick the number.
    if (_tickDuration != null) {
      double totalDuration = _tickDuration!.inSeconds.toDouble();
      _tickAccumulatedTime += dt;
      _tickRateAccumulatedTime += dt;

      if (_tickRateAccumulatedTime > _tickRateTime) {
        // Do the tick.
        double totalDiff = _tickToTarget - _startTickingNumber;
        double progressRate = totalDuration != 0 ?  _tickAccumulatedTime / totalDuration : 1;
        double currentDiff = totalDiff * progressRate;

        //Set the thing.
        set(_startTickingNumber + currentDiff);

        _tickRateAccumulatedTime -= _tickRateTime;
      }

      // log('$totalDuration / $_tickAccumulatedTime');

      if (_tickAccumulatedTime >= totalDuration) {
        // log('[Tick Complete!]');
        set(_tickToTarget);
        _tickDuration = null;
        onTickComplete?.call();
      }
    }

    super.update(dt);
  }

  //--

  /// 設定顯示數字。
  bool set(num value) {
    // log('set: $value');
    if (_initializeSuccess) {
      if (value >= 0) {
        int usingSpriteComponentIndex = 0;

        // 取得小數位以下數字，以 fixedDecimalPlaceLength 作為取得長度依據。
        List<int> belowDecimalDigits = _getBelowDecimalDigits(value as double, fixedDecimalPlaceLength);

        // log('[belowDecimalDigits]: ${belowDecimalDigits.join(', ')}');

        //從最低位到最高位。
        for (int i = 0; i < belowDecimalDigits.length; ++i) {
          // 防爆炸，高過 _spriteComponents 可以顯示的長度就乾脆不做。
          if (usingSpriteComponentIndex < _spriteComponents.length) {
            //設定此位數字。
            _spriteComponents[usingSpriteComponentIndex].sprite = _numberSprites[belowDecimalDigits[i]];
            _spriteComponents[usingSpriteComponentIndex].size = _numberSprites[belowDecimalDigits[i]].originalSize;
            usingSpriteComponentIndex++;
          }
        }

        //補小數點?
        if (belowDecimalDigits.isNotEmpty && _decimalPointSprite != null) {
          // 防爆炸，高過 _spriteComponents 可以顯示的長度就乾脆不做。
          if (usingSpriteComponentIndex < _spriteComponents.length) {
            //設定小數點。
            _spriteComponents[usingSpriteComponentIndex].sprite = _decimalPointSprite;
            _spriteComponents[usingSpriteComponentIndex].size = _decimalPointSprite!.originalSize;
            usingSpriteComponentIndex++;
          }
        }

        // 取得整數部分各個位數數字。
        List<int> aboveDecimalDigits = _getIntDigits(value.floor());
        // 從個位到最高位，依序處理。
        for (int i = 0; i < aboveDecimalDigits.length; ++i) {
          // 防爆炸，高過 _spriteComponents 可以顯示的長度就乾脆不做。
          if (usingSpriteComponentIndex < _spriteComponents.length) {
            // 首先判斷這個位數是否需要被顯示。
            bool digitVisible = true;
            if (fixedDigitLength != 0 && i >= fixedDigitLength) {
              // 超過指定長度，因此不顯示此位數。
              digitVisible = false;
            }

            if (fixedDigitLength == 0 && i >= aboveDecimalDigits.length) {
              // 動態長度，而且超過解析位數數字。
              digitVisible = false;
            }

            if (digitVisible) {
              if (i < aboveDecimalDigits.length) {
                //設定此位數字。
                _spriteComponents[usingSpriteComponentIndex].sprite = _numberSprites[aboveDecimalDigits[i]];
                _spriteComponents[usingSpriteComponentIndex].size = _numberSprites[aboveDecimalDigits[i]].originalSize;
                // log ('[$i] set to digit number: ${digits[i]}');
              } else {
                //Over the number length.
                _spriteComponents[usingSpriteComponentIndex].sprite = _numberSprites[0];
                _spriteComponents[usingSpriteComponentIndex].size = _numberSprites[0].originalSize;
                // log ('[$i] set to digit number: 0!');
              }
            } else {
              //隱藏，弄一個大小為 0 的圖片。
              _spriteComponents[usingSpriteComponentIndex].sprite = _numberSprites[0];
              _spriteComponents[usingSpriteComponentIndex].size = Vector2.zero();
              // log ('[$i] set to hide.');
            }

            usingSpriteComponentIndex++;

            //檢查是否要補一個分隔用逗號。
            if (enableThousandsSeparator && _commaSprite != null && (i + 1) % 3 == 0) {
              if ((i + 1) < aboveDecimalDigits.length || (fixedDigitLength != 0 && (i + 1) < fixedDigitLength)) {
                //這是一個該補的地方。
                _spriteComponents[usingSpriteComponentIndex].sprite = _commaSprite;
                if (digitVisible) {
                  _spriteComponents[usingSpriteComponentIndex].size = _commaSprite!.originalSize;
                } else {
                  _spriteComponents[usingSpriteComponentIndex].size = Vector2.zero();
                }
                usingSpriteComponentIndex++;
              }
            }
          }
        }

        // 考慮 fixedDigitLength, 把需要補 0 的補上。
        for (int i = aboveDecimalDigits.length; i < fixedDigitLength; ++i) {
          _spriteComponents[usingSpriteComponentIndex].sprite = _numberSprites[0];
          _spriteComponents[usingSpriteComponentIndex].size = _numberSprites[0].originalSize;
          usingSpriteComponentIndex++;

          //補逗號?
          if (enableThousandsSeparator && _commaSprite != null && (i + 1) % 3 == 0 && (i + 1) < fixedDigitLength) {
            //這是一個該補的地方。
            _spriteComponents[usingSpriteComponentIndex].sprite = _commaSprite;
            _spriteComponents[usingSpriteComponentIndex].size = _commaSprite!.originalSize;
            usingSpriteComponentIndex++;
          }
        }

        // 處理剩餘的東西，基本上隱藏剩餘全部的就對了。
        for (int i = usingSpriteComponentIndex; i < _spriteComponents.length; ++i) {
          _spriteComponents[i].sprite = _numberSprites[0];
          _spriteComponents[i].size = Vector2.zero();
        }

        //重新排列。
        _reArrangeSpriteComponents();

        // 確立當前顯示數字。
        _currentNumber = value;

        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  /// 取得當前顯示數字。
  double get currentNumber {
    return _currentNumber;
  }

  /// 數字跳動更新效果，在 duration 時間內達到指定目標數字。
  /// 這個方法可以重複被呼叫，新的呼叫會取代掉正在做的目標。
  bool tickTo(num value, {Duration duration = const Duration(seconds: 1)}) {
    if (_initializeSuccess) {
      if (value >= 0) {
        // Duration 只要設東西就會開始數字跳動。
        _tickDuration = duration;
        _startTickingNumber = _currentNumber;
        _tickToTarget = value as double;
        _tickAccumulatedTime = 0;
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // 內部用: Calculate and get all digits of a input number. From low to high.
  List<int> _getIntDigits(int value) {
    List<int> returnList = [];

    while (value > 0) {
      //求於數。
      returnList.add(value % 10);
      //降未。
      value = value ~/ 10;
    }

    // 發現什麼鳥都沒取到就補 0.
    if (returnList.isEmpty) {
      returnList.add(0);
    }

    return returnList;
  }

  // 內部用: 取得小數點以下位數數字，從最低到最高，根據傳入 decimal 來決定要取幾位。
  // 取不到會無腦補 0
  List<int> _getBelowDecimalDigits(double value, int decimalPlace) {
    String str = value.toString();
    if (str.contains('.')) {
      List<String> segments = str.split('.');
      if (segments.length == 2) {
        String belowDecimalStr = segments[1];
        if (decimalPlace >= 1) {
          List<int> returnList = [];
          // 就取 decimalPlace 位，不多不少，就是我們要的。
          for (int i = 0; i < decimalPlace; ++i) {
            if (i < belowDecimalStr.length) {
              int? digit = int.tryParse(belowDecimalStr[i]);
              returnList.insert(0, digit ?? 0);
            } else {
              returnList.insert(0, 0);
            }
          }
          return returnList;
        } else if (decimalPlace == -1) {
          List<int> returnList = [];
          //動態長度，最長為 2
          for (int i = 0; i < 2; ++i) {
            if (i < belowDecimalStr.length) {
              int? digit = int.tryParse(belowDecimalStr[i]);
              returnList.insert(0, digit ?? 0);
            } else {
              //超過無視
            }
          }
          return returnList;

        } else {
          //Ignore these cases.
        }
      } else {
        //Huh?
      }
    } else {
      //Err... not decimal point?
    }
    return [];
  }

  // 內部用: 這會重新考慮並排列所有 SpriteComponents.
  _reArrangeSpriteComponents() {
    //計算邏輯總寬及邏輯高。
    double logicWidth = 0;
    double logicHeight = 0;
    for (int i = 0; i < _spriteComponents.length; ++i) {
      _spriteComponents[i].position = Vector2(-logicWidth, 0);
      logicWidth += _spriteComponents[i].width;
      if (_spriteComponents[i].height > logicHeight) {
        logicHeight = _spriteComponents[i].height;
      }
    }

    //使用 logicWidth 與 logicHeight 並考慮 anchor 來正確擺放整組 _spriteComponents 的位置
    _offsetSpriteComponents(Vector2(logicWidth * (1 - anchor.x), logicHeight * (1 - anchor.y)));
  }

  // 內部用: 所有的圖片做一次位移。
  _offsetSpriteComponents(Vector2 offset) {
    for (int i = 0; i < _spriteComponents.length; ++i) {
      _spriteComponents[i].position = _spriteComponents[i].position + offset;
    }
  }

  //-- Implement OpacityProvider (Support OpacityEffect)

  @override
  double get opacity {
    if (_spriteComponents.isNotEmpty) {
      return _spriteComponents[0].opacity;
    }
    return 0;
  }

  @override
  set opacity(double value) {
    for (var spriteComponent in _spriteComponents) {
      spriteComponent.opacity = value;
    }
  }

}
