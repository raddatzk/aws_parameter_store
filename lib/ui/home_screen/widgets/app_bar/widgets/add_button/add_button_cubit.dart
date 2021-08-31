import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_button_state.dart';

class AddButtonContext extends Cubit<AddButtonState> {
  AddButtonContext() : super(const AddButtonState());

  void set(String bucket, {String? profile, String? app}) {
    emit(AddButtonState(bucket: bucket, profile: profile, app: app));
  }
}
