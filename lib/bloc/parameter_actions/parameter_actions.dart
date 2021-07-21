import 'package:aws_parameter_store/bloc/context/application_context_cubit.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../main.dart';

part 'parameter_actions_state.dart';

class ParameterActions extends Cubit<ParameterActionsState> {
  ParameterActions() : super(const NoParameter());

  final AWSRepository repository = sl<AWSRepository>();

  ParameterLoaded get lastState => (state as ParameterLoaded);

  Future<void> load(String path, String currentBucket) async {
    reset();
    final response = await repository.getParameterHistory(path, currentBucket);
    final parameter = response.parameters.last;
    emit(ParameterLoaded(parameter.relativeName, currentBucket, parameter.profile, parameter.appName, parameter.property, parameter.value, parameter.version, parameter.lastModifiedDate));
  }

  void reset() {
    emit(const NoParameter());
  }

  void initiateSave() {
    emit(const InitiateSave());
  }

  void initiateDelete() {
    emit(const InitiateDelete());
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
    return "$name/$property";
  }

  void addDraft(String bucket, String profile, String app, String property) async {
    emit(ParameterLoaded(_generateName(profile, app, property), bucket, profile, app, property, null, 0, null));
  }

  void save(String name, String value, String currentBucket) async {
    await repository.putParameter(name, value, currentBucket);
    load(name, currentBucket);
  }

  void delete(String name, String currentBucket) async {
    await repository.deleteParameter(name, currentBucket);
    sl<ApplicationContext>().removeCurrentSelected();
  }
}
