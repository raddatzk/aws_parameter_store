part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();

  @override
  List<Object?> get props => [];
}

class GoToHome extends LoginState {
  const GoToHome();

  @override
  List<Object?> get props => [];
}

class MissingProperty extends LoginState {
  final String property;

  const MissingProperty(this.property);

  @override
  List<Object?> get props => [property];
}