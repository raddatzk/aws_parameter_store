import 'dart:convert';

import 'package:aws_parameter_store/aws/model/responses.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/app_bar.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/column_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'parameter_column_state.dart';

class ParameterColumnContext extends Cubit<ParameterColumnState> {
  ParameterColumnContext() : super(const ParameterColumnState(null));

  final AWSRepository repository = sl<AWSRepository>();

  bool draft = false;
  String currentValue = "";

  void createDraft(String bucket, String profile, String app, String property) {
    emit(ParameterColumnState(ParameterContentWrapper.draft(_generateName(profile, app, property), bucket, profile, app, property), version: 0));
  }

  bool isInCreation() {
    return state.version != null && state.version != 0;
  }

  Future<void> loadParameter(String bucket, String path) async {
    sl<AwsAppBarContext>().startLoading();
    emit(ParameterColumnState(
      ParameterContentWrapper.fromHistory(bucket, await repository.getParameterHistory(path, bucket)),
    ));
    sl<AwsAppBarContext>().stopLoading();
  }

  void updateValueWith(String value) {
    if (currentValue != value) {
      draft = true;
      currentValue = value;
      sl<AwsAppBarContext>().modified();
    } else {
      draft = false;
      sl<AwsAppBarContext>().reset();
    }
  }

  void changeVersionTo(int version) {
    emit(state.copyWith(version: version));
  }

  void save() async {
    sl<AwsAppBarContext>().startLoading();
    final currentVersion = _getCurrentParameter();
    await repository.putParameter(currentVersion.path, currentValue, currentVersion.bucket);
    emit(ParameterColumnState(ParameterContentWrapper.fromHistory(currentVersion.bucket, await repository.getParameterHistory(currentVersion.path, currentVersion.bucket))));
    sl<ColumnViewContext>().reloadCurrentBucket();
    draft = false;
    sl<AwsAppBarContext>().stopLoading();
  }

  void delete() async {
    sl<AwsAppBarContext>().startLoading();
    final currentVersion = _getCurrentParameter();
    await repository.deleteParameter(_generateName(currentVersion.profile, currentVersion.app, currentVersion.property), currentVersion.bucket);
    sl<ColumnViewContext>().removeCurrentSelected();
    sl<ColumnViewContext>().reloadCurrentBucket();
    sl<AwsAppBarContext>().stopLoading();
  }

  void cancelParameter() {
    draft = false;
  }

  ParameterContent _getCurrentParameter() {
    return _getParameterForVersion(state.version);
  }

  ParameterContent _getParameterForVersion(int? version) {
    if (version == null) {
      return state.content!.data.last;
    }
    return state.content!.data[version];
  }

  String _generateName(String profile, String app, String property) {
    String name = "";
    if (app == "all applications") {
      name = "application";
    } else {
      name = app;
    }
    if (profile != "all profiles") {
      name = "${name}_${profile.replaceAll(" profile", "")}";
    }
    return "$name/${base64.encode(utf8.encode(property)).replaceAll("=", "")}";
  }
}
