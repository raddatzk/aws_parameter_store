import 'package:aws_parameter_store/aws/aws_parameter_store.dart';
import 'package:aws_parameter_store/aws/model/requests.dart';
import 'package:aws_parameter_store/aws/model/responses.dart';
import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:collection/collection.dart';

import '../main.dart';

class AWSRepository {
  final AWSParameterStore awsParameterStore;

  PreferencesRepository get preferences => sl<PreferencesRepository>();

  AWSRepository(this.awsParameterStore);

  String getBucket(String name) => preferences.getBucketByName(name).url;

  String getProfile(String name) => preferences.getBucketByName(name).awsProfile;

  Future<PutParameterResponse> putParameter(String key, String value, String bucketName) {
    return awsParameterStore.putParameter(key, value, getBucket(bucketName), profile: getProfile(bucketName));
  }

  Future<ResponseWrapper<GetParametersResponse>> getParameters(String key, String bucketName, {int? version}) {
    return awsParameterStore.getParameter(key, getBucket(bucketName), profile: getProfile(bucketName), version: version);
  }

  Future<List<GetParameterHistoryResponse>> getParameterHistory(String key, String bucketName) async {
    return (await awsParameterStore.getParameterHistory(key, getBucket(bucketName), profile: getProfile(bucketName))).parameters;
  }

  GetParametersByPathResponse getDraftParameterByPath(String path, String bucketName) {
    return GetParametersByPathResponse(path, "String", "", 0, DateTime.now(), "", "text")..request = GetParametersByPathRequest(path, bucketName, getProfile(bucketName), false);
  }

  Future<Map<String, Map<String, List<GetParametersByPathResponse>>>> getParametersByPath(String path, String bucketName, {bool recursive = true}) async {
    var response = (await awsParameterStore.getParametersByPath(path, getBucket(bucketName), profile: getProfile(bucketName), recursive: recursive));
    final groupedByProfile = groupBy(response.parameters, (e) => (e as GetParametersByPathResponse).profile);
    final profileMap = <String, Map<String, List<GetParametersByPathResponse>>>{};
    for (final entry in groupedByProfile.entries) {
      profileMap.putIfAbsent(entry.key, () => groupBy(entry.value, (e) => (e).appName));
    }

    return profileMap;
  }

  Future deleteParameter(String key, String bucketName) {
    return awsParameterStore.deleteParameter(key, getBucket(bucketName), profile: getProfile(bucketName));
  }

  Future<PutParameterResponse> revertParameterToVersion(String key, int version, String bucketName) {
    return getParameters(key, bucketName, version: version).then((response) => putParameter(key, response.parameters[0].value, bucketName));
  }
}
