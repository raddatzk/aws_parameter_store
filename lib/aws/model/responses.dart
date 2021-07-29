import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'requests.dart';

part 'responses.g.dart';

class ResponseWrapper<T> {
  final List<T> parameters;
  final List<String> invalidParameters;

  ResponseWrapper(this.parameters, this.invalidParameters);

  bool get failed => parameters.isEmpty && invalidParameters.isNotEmpty;
}

@JsonSerializable(createToJson: false)
class PutParameterResponse {
  @JsonKey(name: "Version")
  final int version;
  @JsonKey(name: "Tier")
  final String tier;

  PutParameterResponse(this.version, this.tier);

  factory PutParameterResponse.fromJson(Map<String, dynamic> json) => _$PutParameterResponseFromJson(json);
}

abstract class AbstractParameterResponse<T extends AbstractRequest> {
  String get name;

  T get request;

  String get relativeName => name.replaceAll(request.bucket, "").substring(1);

  String get context => relativeName.split("/").first;

  String get appName {
    final appName = context.split("_").first;
    return appName == "application" ? "all applications" : appName;
  }

  String get profile {
    try {
      return "${context.split("_")[1]} profile";
    } on Error {
      return "all profiles";
    }
  }

  String get property {
    try {
      var property = relativeName.split("/").last;
      var paddingLength = 4 - (property.length % 4);
      final padding = List<String>.generate(paddingLength % 4, (_) => "=").join("");
      property = "$property$padding";
      return utf8.decode(base64.decode("$relativeName$padding".split("/").last));
    } on Exception {
      return relativeName.split("/").last;
    }
  }

  bool get hasProperty {
    return property != context;
  }
}

@JsonSerializable(createToJson: false)
class GetParametersResponse extends AbstractParameterResponse<GetParameterRequest> {
  @JsonKey(name: "Name")
  @override
  final String name;
  @JsonKey(name: "Type")
  final String type;
  @JsonKey(name: "Value")
  final String value;
  @JsonKey(name: "Version")
  final int version;
  @JsonKey(name: "LastModifiedDate")
  final DateTime lastModifiedDate;
  @JsonKey(name: "ARN")
  final String arn;
  @JsonKey(name: "DataType")
  final String dataType;

  @JsonKey(ignore: true)
  @override
  late final GetParameterRequest request;

  GetParametersResponse(this.name, this.type, this.value, this.version, this.lastModifiedDate, this.arn, this.dataType);

  factory GetParametersResponse._fromJson(Map<String, dynamic> json) => _$GetParametersResponseFromJson(json);

  static ResponseWrapper<GetParametersResponse> fromJson(Map<String, dynamic> json, GetParameterRequest request) {
    return ResponseWrapper(
        (json["Parameters"] as List).map((e) => GetParametersResponse._fromJson(e)..request = request).toList(), (json['InvalidParameters'] as List<dynamic>).map((e) => e as String).toList());
  }
}

@JsonSerializable(createToJson: false)
class GetParameterHistoryResponse extends AbstractParameterResponse<GetParameterHistoryRequest> {
  @JsonKey(name: "Name")
  @override
  final String name;
  @JsonKey(name: "Type")
  final String type;
  @JsonKey(name: "LastModifiedDate")
  final DateTime lastModifiedDate;
  @JsonKey(name: "LastModifiedUser")
  final String lastModifiedUser;
  @JsonKey(name: "Value")
  final String value;
  @JsonKey(name: "Version")
  final int version;
  @JsonKey(name: "Labels")
  final List<String> labels;
  @JsonKey(name: "Tier")
  final String tier;
  @JsonKey(name: "Policies")
  final List<String> policies;
  @JsonKey(name: "DataType")
  final String dataType;

  @JsonKey(ignore: true)
  @override
  late final GetParameterHistoryRequest request;

  GetParameterHistoryResponse(this.name, this.type, this.lastModifiedDate, this.lastModifiedUser, this.value, this.version, this.labels, this.tier, this.policies, this.dataType);

  factory GetParameterHistoryResponse._fromJson(Map<String, dynamic> json) => _$GetParameterHistoryResponseFromJson(json);

  static ResponseWrapper<GetParameterHistoryResponse> fromJson(Map<String, dynamic> json, GetParameterHistoryRequest request) {
    return ResponseWrapper((json["Parameters"] as List).map((e) => GetParameterHistoryResponse._fromJson(e)..request = request).toList(), []);
  }
}

DateTime dateTimeFromJson(dynamic json) {
  try {
    return DateTime.parse(json as String);
  } on Error {
    return DateTime.fromMillisecondsSinceEpoch(((json as double) * 1000).floor());
  }
}

@JsonSerializable(createToJson: false)
class GetParametersByPathResponse extends AbstractParameterResponse<GetParametersByPathRequest> {
  @JsonKey(name: "Name")
  @override
  final String name;
  @JsonKey(name: "Type")
  final String type;
  @JsonKey(name: "Value")
  final String value;
  @JsonKey(name: "Version")
  final int version;
  @JsonKey(name: "LastModifiedDate", fromJson: dateTimeFromJson)
  final DateTime lastModifiedDate;
  @JsonKey(name: "ARN")
  final String arn;
  @JsonKey(name: "DataType")
  final String dataType;

  @JsonKey(ignore: true)
  @override
  late final GetParametersByPathRequest request;

  GetParametersByPathResponse(this.name, this.type, this.value, this.version, this.lastModifiedDate, this.arn, this.dataType);

  factory GetParametersByPathResponse._fromJson(Map<String, dynamic> json) => _$GetParametersByPathResponseFromJson(json);

  static ResponseWrapper<GetParametersByPathResponse> fromJson(Map<String, dynamic> json, GetParametersByPathRequest request) {
    return ResponseWrapper(
        (json["Parameters"] as List)
            .map(
              (e) => GetParametersByPathResponse._fromJson(e)..request = request,
        )
            .toList(),
        []);
  }
}
