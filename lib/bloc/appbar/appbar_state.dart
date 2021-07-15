part of 'appbar_cubit.dart';

class AppBarState extends Equatable {
  const AppBarState(this.showParameterActions);

  final bool showParameterActions;

  @override
  List<Object?> get props => [showParameterActions];
}