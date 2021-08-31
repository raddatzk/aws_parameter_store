part of 'column_view_cubit.dart';

abstract class ColumnViewState extends Equatable {
  const ColumnViewState();
}

class ColumnViewInitial extends ColumnViewState {
  const ColumnViewInitial();

  @override
  List<Object?> get props => [];
}

abstract class HasParameterState {
  String get bucket;

  String? get profile;

  String? get app;

  String? get property;
}

class AskToDiscardChanges extends ColumnViewState implements HasParameterState {
  const AskToDiscardChanges(this.bucket, this.profile, this.app, this.property, this.lastState);

  @override
  final String bucket;
  @override
  final String? profile;
  @override
  final String? app;
  @override
  final String? property;
  final ColumnViewPrepared lastState;

  @override
  List<Object?> get props => [bucket, profile, app, property, lastState];
}

class ColumnViewPrepared extends ColumnViewState implements HasParameterState {
  final Map<String, Map<String, Map<String, List<GetParametersByPathResponse>>>?> data;
  @override
  final String bucket;
  @override
  final String? profile;
  @override
  final String? app;
  @override
  final String? property;

  const ColumnViewPrepared(
    this.data,
    this.bucket, {
    this.profile,
    this.app,
    this.property,
  });

  @override
  List<Object?> get props => [data, bucket, profile, app, property];
}
