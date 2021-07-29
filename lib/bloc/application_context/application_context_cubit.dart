import 'dart:convert';

import 'package:aws_parameter_store/aws/model/responses.dart';
import 'package:aws_parameter_store/bloc/app_bar_context/app_bar_context_cubit.dart';
import 'package:aws_parameter_store/bloc/application_context/application_context_service.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'application_context_parameter_service.dart';
part 'application_context_state.dart';

typedef ContextData = Map<String, Map<String, Map<String, List<GetParametersByPathResponse>>>?>;

class ApplicationContext extends Cubit<ApplicationContextState> {
  ApplicationContext() : super(const ApplicationContextInitial());

  final ApplicationContextService service = ApplicationContextService();
  final ApplicationContextParameterService parameterService = sl<ApplicationContextParameterService>();

  ContextData data = {};

  final AWSRepository repository = sl<AWSRepository>();

  ApplicationContextPrepared get lastState => state as ApplicationContextPrepared;

  void goTo(String bucket, {String? profile, String? app, String? property, bool forceAbort = false, ApplicationContextPrepared? lastState}) async {
    if (parameterService.draft && !forceAbort) {
      emit(DiscardChanges(bucket, profile, app, property, this.lastState));
    } else {
      sl<AppBarContext>().leaveParameter(bucket, profile, app);
      parameterService.cancelParameter();
      sl<AppBarContext>().startLoading();
      if (data[bucket] == null) {
        data = await service.loadDataForBucket(data, bucket);
      }
      if (parameterService.isInCreation() && lastState != null) {
        _remove(lastState.bucket, lastState.profile!, lastState.app!, lastState.property!);
      }
      ParameterContentWrapper? parameter = await parameterService.tryToLoadParameter(data, bucket, profile, app, property);
      emit(ApplicationContextPrepared(
        data,
        bucket,
        profile: profile,
        app: app,
        property: property,
        parameter: parameter,
      ));
      sl<AppBarContext>().stopLoading();
    }
  }

  void loadFirstOf(List<String> bucketNames) async {
    sl<AppBarContext>().startLoading();
    data = await service.loadFirstOf(data, bucketNames);
    emit(ApplicationContextPrepared(
      data,
      bucketNames.first,
    ));
    sl<AppBarContext>().stopLoading();
  }

  Future<void> reloadCurrentBucket() async {
    sl<AppBarContext>().startLoading();
    final bucket = lastState.bucket;
    final profile = lastState.profile;
    final app = lastState.app;
    final property = lastState.property;
    data = await service.loadDataForBucket(data, bucket);
    ParameterContentWrapper? parameter = await parameterService.tryToLoadParameter(data, bucket, profile, app, property);
    emit(ApplicationContextPrepared(
      data,
      bucket,
      profile: profile,
      app: app,
      property: property,
      parameter: parameter,
    ));
    sl<AppBarContext>().stopLoading();
  }

  void addNewParameterAsDraft(String bucket, String profile, String app, String property) {
    data = service.addParameter(data, bucket, profile, app, property);
    final ParameterContentWrapper parameter = ParameterContentWrapper.draft(bucket, profile, app, property);
    parameterService.addParameter(parameter);
    emit(ApplicationContextPrepared(
      data,
      bucket,
      profile: profile,
      app: app,
      property: property,
      parameter: parameter,
    ));
  }

  void updateDraft(value) {
    parameterService.updateParameter(value);
  }

  void _remove(String bucket, String profile, String app, String property) {
    data = service.removeFromData(data, bucket, profile, app, property);
  }

  void removeCurrentSelected() {
    var bucket = lastState.bucket;
    var profile = lastState.profile!;
    var app = lastState.app!;

    final profiles = data[bucket]!;
    final apps = data[bucket]![profile]!;

    _remove(bucket, profile, app, lastState.property!);

    if (data[bucket]![profile]!.isEmpty) {
      emit(ApplicationContextPrepared(
        data,
        bucket,
        profile: profiles.keys.first,
        app: null,
        property: null,
      ));
    } else if (data[bucket]![profile]![app]!.isEmpty) {
      emit(ApplicationContextPrepared(
        data,
        bucket,
        profile: profile,
        app: apps.keys.first,
        property: null,
      ));
    } else {
      emit(ApplicationContextPrepared(
        data,
        bucket,
        profile: profile,
        app: app,
        property: null,
      ));
    }
  }

  void save(String bucket, String profile, String app, String property, String value) async {
    sl<AppBarContext>().startLoading();
    await parameterService.saveParameter(value);
    await reloadCurrentBucket();
    sl<AppBarContext>().stopLoading();
  }

  void delete(String bucket, String profile, String app, String property) async {
    sl<AppBarContext>().startLoading();
    await parameterService.deleteParameter();
    removeCurrentSelected();
    sl<AppBarContext>().stopLoading();
  }

  void changedVersion(int version, bool modified) {
    parameterService.changeVersionTo(version, modified);
  }
}
