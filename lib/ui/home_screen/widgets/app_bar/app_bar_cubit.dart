import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/column_view.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/widgets.dart';

import '../../../../main.dart';

part 'app_bar_state.dart';

class AwsAppBarContext extends Cubit<AwsAppBarContextState> {
  AwsAppBarContext() : super(const AwsAppBarContextState(false, null));

  void onSettingsPressed(BuildContext context) {
    FLog.info(text: "test");
    Navigator.pushReplacementNamed(context, "/setup");
  }

  void onRefreshPressed() {
    sl<ColumnViewContext>().reloadCurrentBucket();
  }

  void startLoading() {
    emit(state.withLoading(true));
  }

  void stopLoading() {
    emit(state.withLoading(false));
  }

  void modified() {
    emit(state.withModified(true));
  }

  void enterParameter() {
    emit(state.withModified(false));
  }

  void reset() {
    emit(state.withModified(false));
  }

  void exitParameter() {
    emit(state.withModified(null));
  }
}
