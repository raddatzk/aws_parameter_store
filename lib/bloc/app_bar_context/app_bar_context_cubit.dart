import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../main.dart';

part 'app_bar_context_state.dart';

class AppBarContext extends Cubit<AppBarContextState> {
  AppBarContext() : super(const ParameterNotAvailable());

  final AWSRepository repository = sl<AWSRepository>();

  void loadParameter(String bucket, String profile, String app, String property, String value) async {
    emit(ParameterAvailable(
      modified: false,
      bucket: bucket,
      profile: profile,
      app: app,
      property: property,
      value: value,
    ));
  }

  void updateParameter(bool modified, String value) {
    if (state is ParameterAvailable) {
      final _state = (state as ParameterAvailable);
      emit(ParameterAvailable(
        modified: modified,
        bucket: _state.bucket,
        profile: _state.profile,
        app: _state.app,
        property: _state.property,
        value: value,
      ));
    } else {
      emit(const ParameterNotAvailable());
    }
  }

  void leaveParameter(String bucket, String? profile, String? app) {
    emit(ParameterNotAvailable(
      bucket: bucket,
      profile: profile,
      app: app,
    ));
  }

  void startLoading() {
    emit(state.withLoading(true));
  }

  void stopLoading() {
    emit(state.withLoading(false));
  }

  void changeVersionTo(String bucket, String profile, String app, String property, String value, bool modified) {
    emit(ParameterAvailable(
      modified: modified,
      bucket: bucket,
      profile: profile,
      app: app,
      property: property,
      value: value,
    ));
  }
}
