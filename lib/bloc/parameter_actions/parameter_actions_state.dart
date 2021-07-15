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
  final GetParameterHistoryResponse response;

  const ParameterLoaded(this.response);

  @override
  List<Object?> get props => [response];
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
