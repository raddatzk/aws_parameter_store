import 'package:hive_flutter/hive_flutter.dart';

part 'preferences_repository.g.dart';

@HiveType(typeId: 0)
class Bucket extends HiveObject {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String awsProfile;

  Bucket(this.url, this.awsProfile);
}

class PreferencesRepository {
  var buckets = Hive.box<Bucket>('buckets');

  Future<int> clear() {
    return buckets.clear();
  }

  Bucket getBucketByName(String name) {
    return buckets.get(name)!;
  }

  Bucket setBucketFor(String name, Bucket bucket) {
    buckets.put(name, bucket);
    return bucket;
  }

  List<String> getNames() {
    return buckets.keys.map((e) => e as String).toList();
  }

  List<Bucket> getAllBuckets() {
    return buckets.values.toList();
  }

  void deleteBucket(String name) {
    buckets.delete(name);
  }

  bool hasBuckets() {
    return buckets.values.isNotEmpty;
  }
}
