import 'dart:convert';

import 'package:aws_parameter_store/bloc/appbar/appbar_cubit.dart';
import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';
import 'package:meta/meta.dart';

import '../../main.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  final repository = sl<PreferencesRepository>();

  void loginWithCloudfoundryJson(String data) {
    try {
      var properties = AWSCloudFoundryParameterStoreProperties.fromJson(jsonDecode(data));
      _loginWith(properties);
    } on Exception {
      emit(const MissingProperty("asdf"));
    }
  }

  void _loginWith(AWSParameterStoreProperties properties) async {
    var preferences = Preferences(properties.accessKey, properties.secretAccessKey, properties.region, properties.root);
    await repository.set(preferences);

    var awsParameterStore = AWSParameterStore(properties);
    sl.registerSingleton<AWSRepository>(AWSRepository(awsParameterStore));

    sl.registerSingleton<ParameterActions>(ParameterActions());
    sl.registerSingleton<AppBarCubit>(AppBarCubit());

    var awsCubit = OverviewCubit();
    await awsCubit.initialize();
    sl.registerSingleton<OverviewCubit>(awsCubit);

    emit(const GoToHome());
  }
}
