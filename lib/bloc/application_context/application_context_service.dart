import 'dart:convert';

import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';

class ApplicationContextService {
  final AWSRepository repository = sl<AWSRepository>();

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

  ContextData addParameter(ContextData data, String bucket, String profile, String app, String property) {
    final currentBucket = data[bucket]!;
    var currentProfile = currentBucket[profile];
    if (currentProfile == null) {
      currentProfile = {};
      currentBucket[profile] = currentProfile;
    }
    var currentApp = currentProfile[app];
    if (currentApp == null) {
      currentApp = [];
      currentProfile[app] = currentApp;
    }
    if (!currentApp.any((element) => element.property == property)) {
      currentApp.add(repository.getDraftParameterByPath(_generateName(profile, app, property), bucket));
    }

    return data;
  }

  Future<ContextData> loadFirstOf(ContextData data, List<String> bucketNames) async {
    data = {for (var bucketName in bucketNames) bucketName: null};
    return await loadDataForBucket(data, bucketNames.first);
  }

  Future<ContextData> loadDataForBucket(ContextData data, String bucketName) async {
    data[bucketName] = await repository.getParametersByPath("", bucketName);
    return Map.of(data);
  }

  ContextData removeFromData(ContextData data, String bucket, String profile, String app, String property) {
    final profiles = data[bucket]!;
    final apps = data[bucket]![profile]!;
    final properties = data[bucket]![profile]![app]!;

    properties.removeWhere((element) => element.property == property);
    if (properties.isEmpty) {
      apps.remove(app);
      if (apps.keys.isEmpty) {
        profiles.remove(profile);
        if (profiles.isNotEmpty) {
          profile = profiles.keys.first;
        }
      } else {
        app = apps.keys.first;
      }
    } else {
      property = properties.first.property;
    }

    return data;
  }
}
