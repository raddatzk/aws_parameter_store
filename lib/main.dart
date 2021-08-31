import 'dart:io';

import 'package:aws_parameter_store/service/service_locator.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

import 'repository/preferences_repository.dart';
import 'ui/home_screen/home_screen.dart';
import 'ui/home_screen/widgets/column_view/column_view.dart';
import 'ui/setup_screen/setup_screen.dart';

late GetIt sl;

late PackageInfo packageInfo;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FLog.applyConfigurations(LogsConfig()..formatType = FormatType.FORMAT_CUSTOM);
  Hive.initFlutter().then((value) async {
    Hive.registerAdapter(BucketAdapter());
    try {
      await Hive.openBox<Bucket>("buckets");
    } on FileSystemException catch (e) {
      FLog.error(text: "An error occurred when creating settings bucket", exception: e);
    }

    sl = GetIt.I..allowReassignment = true;
    packageInfo = await PackageInfo.fromPlatform();

    ServiceLocator.setSetupDependencies();

    final bucketNames = sl<PreferencesRepository>().getNames();
    if (bucketNames.isNotEmpty) {
      ServiceLocator.setHomeDependencies();
      sl<ColumnViewContext>().loadFirstOf(bucketNames);
    }

    runApp(AWSParameterStoreApp(bucketNames.isNotEmpty));
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
