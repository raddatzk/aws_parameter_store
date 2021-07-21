part of 'parameter_actions.dart';

abstract class ParameterActionsState extends Equatable {
  const ParameterActionsState();
}

class NoParameter extends ParameterActionsState {
  const NoParameter();

  @override
  List<Object?> get props => [];
}

class ParameterLoaded extends ParameterActionsState {
  final String name;
  final String bucket;
  final String profile;
  final String app;
  final String property;
  final String? value;
  final int? version;
  final DateTime? lastModifiedDate;

  const ParameterLoaded(this.name, this.bucket, this.profile, this.app, this.property, this.value, this.version, this.lastModifiedDate);

  @override
  List<Object?> get props => [bucket, profile, app, property, value, lastModifiedDate];
}

class InitiateSave extends ParameterActionsState {
  const InitiateSave();

  @override
  List<Object?> get props => [];
}

class InitiateDelete extends ParameterActionsState {
  const InitiateDelete();

  @override
  List<Object?> get props => [];
}
