import 'package:json_annotation/json_annotation.dart';

part 'betting_result_model.g.dart';  // 这个部分文件名应与你的 Dart 文件名相同，但是扩展名为.g.dart

@JsonSerializable()
class BettingResultModel {
  String uuid; //Ex:注單單號
  int betAmount; //下注金額
  int totalAmount; //總輸鸁金額
  String resultCode; //結果代碼
  int status; //結果狀態
  int exStatus; //額外押注狀態（0:關, 1:開）
  List<Detail> detail; //細項，陣列(有百搭球則size>1)

  BettingResultModel({
    required this.uuid,
    required this.betAmount,
    required this.totalAmount,
    required this.resultCode,
    required this.status,
    required this.exStatus,
    required this.detail,
  });

  factory BettingResultModel.fromJson(Map<String, dynamic> json) => _$BettingResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$BettingResultModelToJson(this);
}

@JsonSerializable()
class Detail {
  List<String> panel; //結果輪面（順序由左至右，由上至下）
  int ratio; //特殊滾輪(倍率)
  List<Result> result; //遊戲結果

  Detail({
    required this.panel,
    required this.ratio,
    required this.result,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class Result {
  String item; //中獎圖形
  int playResult; //中獎金額
  int line; //中獎線
  int linkCount; //連線數
  int odd; //賠率

  Result({
    required this.item,
    required this.playResult,
    required this.line,
    required this.linkCount,
    required this.odd,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
