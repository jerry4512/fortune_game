// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betting_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BettingResultModel _$BettingResultModelFromJson(Map<String, dynamic> json) =>
    BettingResultModel(
      uuid: json['uuid'] as String,
      betAmount: (json['betAmount'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toInt(),
      resultCode: json['resultCode'] as String,
      status: (json['status'] as num).toInt(),
      exStatus: (json['exStatus'] as num).toInt(),
      detail: (json['detail'] as List<dynamic>)
          .map((e) => Detail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BettingResultModelToJson(BettingResultModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'betAmount': instance.betAmount,
      'totalAmount': instance.totalAmount,
      'resultCode': instance.resultCode,
      'status': instance.status,
      'exStatus': instance.exStatus,
      'detail': instance.detail,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      panel: (json['panel'] as List<dynamic>).map((e) => e as String).toList(),
      ratio: (json['ratio'] as num).toInt(),
      result: (json['result'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'panel': instance.panel,
      'ratio': instance.ratio,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      item: json['item'] as String,
      playResult: (json['playResult'] as num).toInt(),
      line: (json['line'] as num).toInt(),
      linkCount: (json['linkCount'] as num).toInt(),
      odd: (json['odd'] as num).toInt(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'item': instance.item,
      'playResult': instance.playResult,
      'line': instance.line,
      'linkCount': instance.linkCount,
      'odd': instance.odd,
    };
