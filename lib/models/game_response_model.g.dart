// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResponse _$GameResponseFromJson(Map<String, dynamic> json) => GameResponse(
      msg: json['msg'] as String,
      resultMap: ResultMap.fromJson(json['resultMap'] as Map<String, dynamic>),
      resultCode: json['resultCode'] as String,
    );

Map<String, dynamic> _$GameResponseToJson(GameResponse instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'resultMap': instance.resultMap,
      'resultCode': instance.resultCode,
    };

ResultMap _$ResultMapFromJson(Map<String, dynamic> json) => ResultMap(
      issue: json['issue'] as String,
      gameInfo: json['gameInfo'] as String,
      totalWinAmount: (json['totalWinAmount'] as num).toInt(),
      uuid: json['uuid'] as String,
      exStatus: (json['exStatus'] as num).toInt(),
      betAmount: (json['betAmount'] as num).toInt(),
      bonusCount: (json['bonusCount'] as num?)?.toInt(),
      cashBalance: (json['cashBalance'] as num).toInt(),
      detail: (json['detail'] as List<dynamic>)
          .map((e) => Detail.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewOrderId: json['viewOrderId'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$ResultMapToJson(ResultMap instance) => <String, dynamic>{
      'issue': instance.issue,
      'gameInfo': instance.gameInfo,
      'totalWinAmount': instance.totalWinAmount,
      'uuid': instance.uuid,
      'exStatus': instance.exStatus,
      'betAmount': instance.betAmount,
      'bonusCount': instance.bonusCount,
      'cashBalance': instance.cashBalance,
      'detail': instance.detail,
      'viewOrderId': instance.viewOrderId,
      'status': instance.status,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      panel: (json['panel'] as List<dynamic>).map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>)
          .map((e) => GameResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      ratio: (json['ratio'] as num).toInt(),
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'panel': instance.panel,
      'result': instance.result,
      'ratio': instance.ratio,
    };

GameResult _$GameResultFromJson(Map<String, dynamic> json) => GameResult(
      item: json['item'] as String,
      playResult: (json['playResult'] as num).toInt(),
      line: (json['line'] as num).toInt(),
      linkCount: (json['linkCount'] as num).toInt(),
      odd: (json['odd'] as num).toInt(),
    );

Map<String, dynamic> _$GameResultToJson(GameResult instance) =>
    <String, dynamic>{
      'item': instance.item,
      'playResult': instance.playResult,
      'line': instance.line,
      'linkCount': instance.linkCount,
      'odd': instance.odd,
    };
