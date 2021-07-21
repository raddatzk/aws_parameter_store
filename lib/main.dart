import 'package:aws_parameter_store/bloc/context/application_context_cubit.dart';
import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/bloc/setup_is_valid/setup_is_valid_cubit.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/parameter_actions/parameter_actions.dart';
import 'bloc/setup_items/setup_items_cubit.dart';
import 'repository/preferences_repository.dart';
import 'ui/home_screen.dart';
import 'ui/setup_screen.dart';

late GetIt sl;

void main() {
  Hive.initFlutter().then((value) async {
    Hive.registerAdapter(BucketAdapter());
    await Hive.openBox<Bucket>("buckets");

    sl = GetIt.I..allowReassignment = true;
    final preferences = PreferencesRepository();
    sl.registerSingleton<PreferencesRepository>(preferences);

    bool hasBuckets = preferences.hasBuckets();
    if (hasBuckets) {
      // sl.registerSingleton<SetupItemsCubit>(SetupItemsCubit());
      // sl.registerSingleton<SetupIsValidCubit>(SetupIsValidCubit());
      final awsParameterStore = AWSParameterStore();
      sl.registerSingleton<AWSRepository>(AWSRepository(awsParameterStore));

      final context = ApplicationContext();
      sl.registerSingleton<ApplicationContext>(context);
      context.initializeFirstOf(preferences.getNames());

      sl.registerSingleton<ParameterActions>(ParameterActions());
      sl.registerSingleton<ScrollHandler>(ScrollHandler());
      // sl.registerSingleton<ApplicationContext>(ApplicationContext());

      // var overviewCubit = OverviewCubit();
      // overviewCubit.initialize();
      // sl.registerSingleton<OverviewCubit>(overviewCubit);
    } else {
      sl.registerSingleton<SetupItemsCubit>(SetupItemsCubit());
      sl.registerSingleton<SetupIsValidCubit>(SetupIsValidCubit());
    }

    runApp(AWSParameterStoreApp(hasBuckets));
  });
}

class AWSParameterStoreApp extends StatelessWidget {
  final bool hasBuckets;

  const AWSParameterStoreApp(this.hasBuckets, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(brightness: Brightness.dark, fontFamily: "JetBrainsMono");
    return MaterialApp(
      title: 'AWS Parameter Store',
      darkTheme: theme,
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.green,
      // ),
      routes: {
        "/home": (context) => const HomeScreen(),
        "/setup": (context) => const SetupScreen(),
      },
      initialRoute: hasBuckets ? "/home" : "/setup",
    );
  }
}