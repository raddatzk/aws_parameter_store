import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scroll_handler_state.dart';

class ScrollHandler extends Cubit<ScrollHandlerState> {
  ScrollHandler() : super(const ScrollHandlerState(true, false));

  void enterParameter() {
    if (state.scrollOverview) {
      emit(const ScrollHandlerState(true, false));
    }
  }

  void exitParameter() {
    emit(const ScrollHandlerState(true, false));
  }

  void hoverOnParameter() {
    emit(const ScrollHandlerState(false, true));
  }
}
