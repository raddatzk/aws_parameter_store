import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';

class AWSRepository {
  final AWSParameterStore awsParameterStore;

  AWSRepository(this.awsParameterStore);

  Future<PutParameterResponse> putParameter(KeyValueParameter parameter) {
    return awsParameterStore.putParameter(parameter);
  }

  Future<ResponseWrapper<GetParametersResponse>> getParameters(List<VersionedParameter> parameters) {
    return awsParameterStore.getParameters(parameters);
  }

  Future<ResponseWrapper<GetParameterHistoryResponse>> getParameterHistory(SimpleParameter parameter) {
    return awsParameterStore.getParameterHistory(parameter);
  }

  Future<ResponseWrapper<GetParametersByPathResponse>> getParametersByPath(SimpleParameter parameter) {
    return awsParameterStore.getParametersByPath(parameter, recursive: true);
  }

  Future deleteParameter(SimpleParameter parameter) {
    return awsParameterStore.deleteParameter(parameter);
  }

  Future<PutParameterResponse> revertParameterToVersion(VersionedParameter parameter) {
    return getParameters([parameter]).then((response) => putParameter(KeyValueParameter(response.parameters[0].name, response.parameters[0].value)));
  }
}
