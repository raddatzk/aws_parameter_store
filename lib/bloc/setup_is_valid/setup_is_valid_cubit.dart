import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'setup_is_valid_state.dart';

class SetupIsValidCubit extends Cubit<SetupIsValidState> {
  SetupIsValidCubit() : super(const SetupIsValidState(false));

  void refresh(bool valid) {
    emit(SetupIsValidState(valid));
  }
}
