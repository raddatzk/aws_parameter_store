import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appbar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  AppBarCubit() : super(const AppBarState(false));

  void enablePropertyActions() {
    emit(const AppBarState(true));
  }

  void disablePropertyActions() {
    emit(const AppBarState(false));
  }
}
