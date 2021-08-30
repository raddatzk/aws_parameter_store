import 'dart:io';

import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/bloc/setup_is_valid/setup_is_valid_cubit.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

import 'aws/aws_parameter_store.dart';
import 'bloc/app_bar_context/app_bar_context_cubit.dart';
import 'bloc/application_context/application_context_cubit.dart';
import 'bloc/setup_items/setup_items_cubit.dart';
import 'repository/preferences_repository.dart';
import 'ui/home_screen.dart';
import 'ui/setup_screen.dart';

late GetIt sl;

late PackageInfo packageInfo;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FLog.applyConfigurations(LogsConfig()
    ..customClosingDivider = ""
    ..customOpeningDivider = ""
    ..formatType = FormatType.FORMAT_CUSTOM
    ..fieldOrderFormatCustom = [
      FieldName.TIMESTAMP,
      FieldName.LOG_LEVEL,
      FieldName.CLASSNAME,
      FieldName.METHOD_NAME,
      FieldName.TEXT,
      FieldName.EXCEPTION,
      FieldName.STACKTRACE,
    ]);
  Hive.initFlutter().then((value) async {
    Hive.registerAdapter(BucketAdapter());
    try {
      await Hive.openBox<Bucket>("buckets");
    } on FileSystemException catch (e) {
      FLog.error(text: "An error occurred when creating settings bucket", exception: e);
    }

    sl = GetIt.I..allowReassignment = true;
    packageInfo = await PackageInfo.fromPlatform();

    final preferences = PreferencesRepository();
    sl.registerSingleton<PreferencesRepository>(preferences);

    bool hasBuckets = preferences.hasBuckets();
    if (hasBuckets) {
      sl.registerSingleton<SetupItemsCubit>(SetupItemsCubit());
      sl.registerSingleton<SetupIsValidCubit>(SetupIsValidCubit());
      final awsParameterStore = AWSParameterStore();
      sl.registerSingleton<AWSRepository>(AWSRepository(awsParameterStore));

      sl.registerSingleton<AppBarContext>(AppBarContext());

      sl.registerSingleton<ApplicationContextParameterService>(ApplicationContextParameterService());

      final context = ApplicationContext();
      sl.registerSingleton<ApplicationContext>(context);
      context.loadFirstOf(preferences.getNames());

      sl.registerSingleton<ScrollHandler>(ScrollHandler());
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
    return MaterialApp(
      title: 'AWS Parameter Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "JetBrainsMono",
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
          secondary: Colors.greenAccent,
        ),
      ),
      routes: {
        "/home": (context) => const HomeScreen(),
        "/setup": (context) => const SetupScreen(),
      },
      initialRoute: hasBuckets ? "/home" : "/setup",
    );
  }
}
