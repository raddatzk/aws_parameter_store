import 'package:aws_parameter_store/aws/model/responses.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/app_bar.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/parameter_column/parameter_column.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import 'column_view_service.dart';

part 'column_view_state.dart';

//                        bucket      profile     app     properties
typedef ContextData = Map<String, Map<String, Map<String, List<GetParametersByPathResponse>>>?>;

class ColumnViewContext extends Cubit<ColumnViewState> {
  ColumnViewContext() : super(const ColumnViewInitial());

  final AWSRepository repository = sl<AWSRepository>();
  final ColumnViewService service = ColumnViewService();

  ContextData data = {};

  ColumnViewPrepared get lastState => state as ColumnViewPrepared;

  Future<void> _tryToOpenParameter(String bucket, String? profile, String? app, String? property) async {
    if (profile != null && app != null && property != null) {
      final content = data[bucket]![profile]![app]!.firstWhere((element) => element.property == property);
      await sl<ParameterColumnContext>().loadParameter(bucket, content.relativeName);
    }
  }

  void goTo(String bucket, {String? profile, String? app, String? property, bool forceAbort = false, ColumnViewPrepared? lastState}) async {
    if (sl<ParameterColumnContext>().draft && !forceAbort) {
      emit(AskToDiscardChanges(bucket, profile, app, property, this.lastState));
    } else {
      sl<AwsAppBarContext>().exitParameter();
      sl<ParameterColumnContext>().cancelParameter();
      await _tryToOpenParameter(bucket, profile, app, property);
      sl<AwsAppBarContext>().startLoading();
      data = await service.loadDataForBucketIfNeeded(data, bucket);
      if (sl<ParameterColumnContext>().isInCreation() && lastState != null) {
        _remove(lastState.bucket, lastState.profile!, lastState.app!, lastState.property!);
      }
      emit(ColumnViewPrepared(
        data,
        bucket,
        profile: profile,
        app: app,
        property: property,
      ));
      sl<AwsAppBarContext>().stopLoading();
    }
  }

  void loadFirstOf(List<String> bucketNames) async {
    sl<AwsAppBarContext>().startLoading();
    data = await service.loadFirstOf(data, bucketNames);
    emit(ColumnViewPrepared(
      data,
      bucketNames.first,
    ));
    sl<AwsAppBarContext>().stopLoading();
  }

  Future<ContextData> reloadCurrentBucket() async {
    sl<AwsAppBarContext>().startLoading();
    final bucket = lastState.bucket;
    final profile = lastState.profile;
    final app = lastState.app;
    final property = lastState.property;
    data = await service.loadDataForBucket(data, bucket);
    emit(ColumnViewPrepared(
      data,
      bucket,
      profile: profile,
      app: app,
      property: property,
    ));
    sl<AwsAppBarContext>().stopLoading();
    return data;
  }

  void addNewParameterAsDraft(String bucket, String profile, String app, String property) {
    data = service.addParameter(data, bucket, profile, app, property);
    emit(ColumnViewPrepared(
      data,
      bucket,
      profile: profile,
      app: app,
      property: property,
    ));
  }

  void _remove(String bucket, String profile, String app, String property) {
    data = service.removeFromData(data, bucket, profile, app, property);
  }

  void removeCurrentSelected() {
    var bucket = lastState.bucket;
    var profile = lastState.profile!;
    var app = lastState.app!;

    _remove(bucket, profile, app, lastState.property!);

    final profiles = data[bucket]!;
    final apps = data[bucket]![profile]!;

    if (!profiles.containsKey(profile)) {
      emit(ColumnViewPrepared(
        data,
        bucket,
        profile: profiles.keys.first,
        app: null,
        property: null,
      ));
    } else if (!apps.containsKey(app)) {
      emit(ColumnViewPrepared(
        data,
        bucket,
        profile: profile,
        app: apps.keys.first,
        property: null,
      ));
    } else {
      emit(ColumnViewPrepared(
        data,
        bucket,
        profile: profile,
        app: app,
        property: null,
      ));
    }
  }
}
