import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';

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

  Future<ResponseWrapper<GetParameterHistoryResponse>> getParameterHistory(String key, String bucketName) {
    return awsParameterStore.getParameterHistory(key, getBucket(bucketName), profile: getProfile(bucketName));
  }

  GetParametersByPathResponse getDraftParameterByPath(String path, String bucketName) {
    return GetParametersByPathResponse(path, "String", "", 0, DateTime.now(), "", "text")..request = GetParametersByPathRequest(path, bucketName, getProfile(bucketName), false);
  }

  Future<ResponseWrapper<GetParametersByPathResponse>> getParametersByPath(String path, String bucketName, {bool recursive = true}) {
    return awsParameterStore.getParametersByPath(path, getBucket(bucketName), profile: getProfile(bucketName), recursive: recursive);
  }

  Future deleteParameter(String key, String bucketName) {
    return awsParameterStore.deleteParameter(key, getBucket(bucketName), profile: getProfile(bucketName));
  }

  Future<PutParameterResponse> revertParameterToVersion(String key, int version, String bucketName) {
    return getParameters(key, bucketName, version: version).then((response) => putParameter(key, response.parameters[0].value, bucketName));
  }
}
