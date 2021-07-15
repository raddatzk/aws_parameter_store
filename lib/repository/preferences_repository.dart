import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'preferences_repository.g.dart';

@HiveType(typeId: 0)
class Preferences extends HiveObject {

  @HiveField(0)
  final String accessKey;
  @HiveField(1)
  final String secretAccessKey;
  @HiveField(2)
  final String region;
  @HiveField(3)
  final String root;

  Preferences(this.accessKey, this.secretAccessKey, this.region, this.root);

  AWSParameterStoreProperties toProperties() {
    return SimpleAWSParameterStoreProperties(accessKey, secretAccessKey, region, root);
  }
}

class PreferencesRepository {
  var box = Hive.box('preferences');

  Preferences get() {
    return box.get("preferences")!;
  }

  Future<void> set(Preferences preferences) async {
    await box.put("preferences", preferences);
  }

  bool hasMinimumSetup() {
    return box.get("preferences") != null;
  }
}