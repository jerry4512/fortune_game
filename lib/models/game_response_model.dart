import 'package:json_annotation/json_annotation.dart';

part 'game_response_model.g.dart';

@JsonSerializable()
class GameResponse {
  String msg;
  ResultMap resultMap;
  String resultCode;

  GameResponse({
    required this.msg,
    required this.resultMap,
    required this.resultCode,
  });

  factory GameResponse.fromJson(Map<String, dynamic> json) => _$GameResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GameResponseToJson(this);
}

@JsonSerializable()
class ResultMap {
  String issue;
  String gameInfo; //遊戲代碼
  int totalWinAmount; //總輸鸁金額
  String uuid; //系統自動產生（Ex:注單單號）
  int exStatus; //額外押注狀態（0:關, 1:開）
  int betAmount; //下注金額
  int? bonusCount;
  int cashBalance; //帳戶餘額
  List<Detail> detail; //細項（陣列(有百搭球則size>1)）
  String viewOrderId;
  int status;  //結果狀態

  ResultMap({
    required this.issue,
    required this.gameInfo,
    required this.totalWinAmount,
    required this.uuid,
    required this.exStatus,
    required this.betAmount,
    this.bonusCount,
    required this.cashBalance,
    required this.detail,
    required this.viewOrderId,
    required this.status,
  });

  factory ResultMap.fromJson(Map<String, dynamic> json) => _$ResultMapFromJson(json);
  Map<String, dynamic> toJson() => _$ResultMapToJson(this);
}

@JsonSerializable()
class Detail {
  List<String> panel; //結果輪面（順序由左至右，由上至下）
  List<GameResult> result; //遊戲結果
  int ratio; //特殊滾輪(倍率)

  Detail({
    required this.panel,
    required this.result,
    required this.ratio,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class GameResult {
  String item; //中獎圖形
  int playResult; //中獎金額
  int line; //中獎線
  int linkCount; //連線數
  int odd; //賠率

  GameResult({
    required this.item,
    required this.playResult,
    required this.line,
    required this.linkCount,
    required this.odd,
  });

  factory GameResult.fromJson(Map<String, dynamic> json) => _$GameResultFromJson(json);
  Map<String, dynamic> toJson() => _$GameResultToJson(this);
}
