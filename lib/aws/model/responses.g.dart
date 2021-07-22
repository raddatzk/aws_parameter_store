// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutParameterResponse _$PutParameterResponseFromJson(Map<String, dynamic> json) {
  return PutParameterResponse(
    json['Version'] as int,
    json['Tier'] as String,
  );
}

Map<String, dynamic> _$PutParameterResponseToJson(PutParameterResponse instance) => <String, dynamic>{
      'Version': instance.version,
      'Tier': instance.tier,
    };

GetParametersResponse _$GetParametersResponseFromJson(Map<String, dynamic> json) {
  return GetParametersResponse(
    json['Name'] as String,
    json['Type'] as String,
    json['Value'] as String,
    json['Version'] as int,
    DateTime.parse(json['LastModifiedDate'] as String),
    json['ARN'] as String,
    json['DataType'] as String,
  );
}

GetParameterHistoryResponse _$GetParameterHistoryResponseFromJson(Map<String, dynamic> json) {
  return GetParameterHistoryResponse(
    json['Name'] as String,
    json['Type'] as String,
    DateTime.parse(json['LastModifiedDate'] as String),
    json['LastModifiedUser'] as String,
    json['Value'] as String,
    json['Version'] as int,
    (json['Labels'] as List<dynamic>).map((e) => e as String).toList(),
    json['Tier'] as String,
    (json['Policies'] as List<dynamic>).map((e) => e as String).toList(),
    json['DataType'] as String,
  );
}

GetParametersByPathResponse _$GetParametersByPathResponseFromJson(Map<String, dynamic> json) {
  return GetParametersByPathResponse(
    json['Name'] as String,
    json['Type'] as String,
    json['Value'] as String,
    json['Version'] as int,
    DateTime.parse(json['LastModifiedDate'] as String),
    json['ARN'] as String,
    json['DataType'] as String,
  );
}
