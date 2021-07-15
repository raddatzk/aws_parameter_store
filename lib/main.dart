import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/appbar/appbar_cubit.dart';
import 'bloc/overview/overview_cubit.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/parameter_actions/parameter_actions.dart';
import 'repository/preferences_repository.dart';
import 'ui/home_screen.dart';
import 'ui/login_screen.dart';

late GetIt sl;

void main() {
  Hive.initFlutter().then((value) async {
    Hive.registerAdapter(PreferencesAdapter());
    await Hive.openBox("preferences");

    sl = GetIt.I
        ..allowReassignment = true;
    final preferences = PreferencesRepository();
    sl.registerSingleton<PreferencesRepository>(preferences);

    var hasMinimumSetup = preferences.hasMinimumSetup();
    if (hasMinimumSetup) {
      var properties = preferences.get().toProperties();
      var awsParameterStore = AWSParameterStore(properties);
      sl.registerSingleton<AWSRepository>(AWSRepository(awsParameterStore));

      sl.registerSingleton<ParameterActions>(ParameterActions());
      sl.registerSingleton<AppBarCubit>(AppBarCubit());

      var overviewCubit = OverviewCubit();
      overviewCubit.initialize();
      sl.registerSingleton<OverviewCubit>(overviewCubit);
    } else {
      sl.registerSingleton<LoginCubit>(LoginCubit());
    }

    runApp(MyApp(hasMinimumSetup));
  });
}

class MyApp extends StatelessWidget {
  final bool hasMinimumSetup;

  const MyApp(this.hasMinimumSetup, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(brightness: Brightness.dark, fontFamily: "JetBrainsMono");
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: theme,
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.green,
      // ),
      routes: {
        "/login": (context) => LoginScreen(),
        "/home": (context) => HomeScreen(),
      },
      initialRoute: hasMinimumSetup ? "/home" : "/login",
    );
  }
}
