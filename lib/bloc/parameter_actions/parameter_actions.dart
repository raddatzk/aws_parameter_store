import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';

import '../../main.dart';

part 'parameter_actions_state.dart';

class ParameterActions extends Cubit<ParameterActionsState> {
  ParameterActions() : super(const NoParameter());

  final AWSRepository repository = sl<AWSRepository>();

  Future<void> load(String path) async {
    final response = await repository.getParameterHistory(SimpleParameter(path));
    emit(ParameterLoaded(response.parameters.last));
  }

  void reset() {
    emit(const NoParameter());
  }

  void initiateSave() {
    emit(const InitiateSave());
  }

  void save(String name, String text) {
    repository.putParameter(KeyValueParameter(name, text));
    load(name);
  }

  void initiateDelete() {
    emit(const InitiateDelete());
  }

  void delete(String name) {
    repository.deleteParameter(SimpleParameter(name));
    sl<OverviewCubit>().initialize();
  }
}
