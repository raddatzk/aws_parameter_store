import 'dart:convert';
import 'dart:io';

import 'package:f_logs/f_logs.dart';

import 'aws_cli_binary_resolver.dart';
import 'error/aws_exception.dart';
import 'model/requests.dart';
import 'model/responses.dart';

class AWSParameterStore {
  final AWSCliBinaryMultiResolver binaryResolver = AWSCliBinaryMultiResolver();

  AWSParameterStore withBinary(String location) {
    binaryResolver.location = location;
    return this;
  }

  Future<PutParameterResponse> putParameter(String key, String value, String bucket, {String? profile}) {
    var request = PutParameterRequest(key, value, bucket, profile);
    return Process.run(binaryResolver.location, request.args).then((result) => _handleResponse(result, successAction: (json) => PutParameterResponse.fromJson(json)));
  }

  Future<ResponseWrapper<GetParametersResponse>> getParameter(String key, String bucket, {String? profile, int? version}) {
    var request = GetParameterRequest(key, bucket, profile, version);
    return Process.run(binaryResolver.location, request.args).then((result) => _handleResponse(result, successAction: (d) => GetParametersResponse.fromJson(d, request)));
  }

  Future<ResponseWrapper<GetParameterHistoryResponse>> getParameterHistory(String key, String bucket, {String? profile}) {
    var request = GetParameterHistoryRequest(key, bucket, profile);
    return Process.run(binaryResolver.location, request.args).then((result) => _handleResponse(result, successAction: (d) => GetParameterHistoryResponse.fromJson(d, request)));
  }

  Future<ResponseWrapper<GetParametersByPathResponse>> getParametersByPath(String key, String bucket, {String? profile, bool recursive = false}) {
    var request = GetParametersByPathRequest(key, bucket, profile, recursive);
    return Process.run(binaryResolver.location, request.args).then((result) => _handleResponse(result, successAction: (d) => GetParametersByPathResponse.fromJson(d, request)));
  }

  Future<void> deleteParameter(String key, String bucket, {String? profile}) {
    var request = DeleteParameterRequest(key, bucket, profile);
    return Process.run(binaryResolver.location, request.args).then((result) => _handleResponse(result, successAction: (d) {}));
  }

  T _handleResponse<T>(ProcessResult result, {T Function(Map<String, dynamic>)? successAction}) {
    if ((result.stdout as String).isEmpty && (result.stderr as String).isNotEmpty) {
      var generateExceptionFromStdErr = _generateExceptionFromStdErr(result.stderr);
      FLog.error(text: "An error occurred when requesting aws", exception: generateExceptionFromStdErr);
      throw generateExceptionFromStdErr;
    } else {
      Map<String, dynamic> response;
      try {
        response = jsonDecode(result.stdout);
        return successAction!(response);
      } on FormatException catch (e) {
        FLog.error(text: "Could not deserialize response from aws: ${result.stdout}", exception: e);
        return successAction!({});
      }
    }
  }

  AWSException _generateExceptionFromStdErr(String stderr) {
    if (stderr.contains("ParameterNotFound")) return AWSParameterNotFoundException(stderr);
    if (stderr.contains("AccessDeniedException")) return AWSAccessDeniedException(stderr);
    return AWSException(stderr);
  }
}
