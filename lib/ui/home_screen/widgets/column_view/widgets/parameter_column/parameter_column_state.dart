part of 'parameter_column_cubit.dart';

class ParameterContent {
  String path;
  String bucket;
  String profile;
  String app;
  String property;
  String value;
  int version;
  DateTime? lastModifiedDate;

  ParameterContent(this.path, this.bucket, this.profile, this.app, this.property, this.value, this.version, this.lastModifiedDate);

  factory ParameterContent.fromHistory(String bucket, GetParameterHistoryResponse response) {
    return ParameterContent(response.relativeName, bucket, response.profile, response.appName, response.property, response.value, response.version, response.lastModifiedDate);
  }
}

class ParameterContentWrapper {
  List<ParameterContent> data;

  ParameterContentWrapper(this.data);

  factory ParameterContentWrapper.fromHistory(String bucket, List<GetParameterHistoryResponse> response) {
    return ParameterContentWrapper(response.map((e) => ParameterContent.fromHistory(bucket, e)).toList());
  }

  factory ParameterContentWrapper.draft(String path, String bucket, String profile, String app, String property) {
    return ParameterContentWrapper([ParameterContent(path, bucket, profile, app, property, "", 0, null)]);
  }

  String get bucket => data.last.bucket;

  String get profile => data.last.profile;

  String get app => data.last.app;

  String get property => data.last.property;

  String get value => data.last.value;

  int get version => data.last.version;
}

class ParameterColumnState extends Equatable {
  final ParameterContentWrapper? content;
  final int? version;

  const ParameterColumnState(
    this.content, {
    this.version,
  });

  @override
  List<Object?> get props => [content, version];

  ParameterColumnState copyWith({int? version}) {
    return ParameterColumnState(content, version: version);
  }
}
