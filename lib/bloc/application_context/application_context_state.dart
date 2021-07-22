part of 'application_context_cubit.dart';

abstract class ApplicationContextState extends Equatable {
  const ApplicationContextState();

  @override
  List<Object?> get props => [];
}

class ApplicationContextInitial extends ApplicationContextState {
  const ApplicationContextInitial();
}

class ParameterContent {
  String bucket;
  String profile;
  String app;
  String property;
  String value;
  int version;
  DateTime? lastModifiedDate;

  ParameterContent(this.bucket, this.profile, this.app, this.property, this.value, this.version, this.lastModifiedDate);

  factory ParameterContent.fromHistory(String bucket, GetParameterHistoryResponse response) {
    return ParameterContent(bucket, response.profile, response.appName, response.property, response.value, response.version, response.lastModifiedDate);
  }
}

class ParameterContentWrapper {
  List<ParameterContent> data;

  ParameterContentWrapper(this.data);

  factory ParameterContentWrapper.fromHistory(String bucket, List<GetParameterHistoryResponse> response) {
    return ParameterContentWrapper(response.map((e) => ParameterContent.fromHistory(bucket, e)).toList());
  }

  factory ParameterContentWrapper.draft(String bucket, String profile, String app, String property) {
    return ParameterContentWrapper([ParameterContent(bucket, profile, app, property, "", 0, null)]);
  }

  String get bucket => data.last.bucket;

  String get profile => data.last.profile;

  String get app => data.last.app;

  String get property => data.last.property;

  String get value => data.last.value;

  int get version => data.last.version;
}

abstract class AbstractState extends ApplicationContextState {
  String get bucket;

  String? get profile;

  String? get app;

  String? get property;
}

class DiscardChanges extends ApplicationContextState implements AbstractState {
  const DiscardChanges(this.bucket, this.profile, this.app, this.property, this.lastState);

  @override
  final String bucket;
  @override
  final String? profile;
  @override
  final String? app;
  @override
  final String? property;
  final ApplicationContextPrepared lastState;

  @override
  List<Object?> get props => [bucket, profile, app, property, lastState];
}

class ApplicationContextPrepared extends ApplicationContextState implements AbstractState {
  final Map<String, Map<String, Map<String, List<GetParametersByPathResponse>>>?> data;
  @override
  final String bucket;
  @override
  final String? profile;
  @override
  final String? app;
  @override
  final String? property;
  final ParameterContentWrapper? parameter;

  const   ApplicationContextPrepared(
    this.data,
    this.bucket, {
    this.profile,
    this.app,
    this.property,
    this.parameter,
  });

  @override
  List<Object?> get props => [data, bucket, profile, app, property, parameter];
}
