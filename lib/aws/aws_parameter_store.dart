import 'dart:convert';
import 'dart:io';

import 'package:f_logs/f_logs.dart';

import 'error/aws_exception.dart';
import 'model/requests.dart';
import 'model/responses.dart';

class AWSParameterStore {

  Future<PutParameterResponse> putParameter(String key, String value, String bucket, {String? profile}) {
    var request = PutParameterRequest(key, value, bucket, profile);
    return Process.run("aws", request.args).then((result) => _handleResponse(result, successAction: (json) => PutParameterResponse.fromJson(json))).catchError((result) => _handleError(result));
  }

  Future<ResponseWrapper<GetParametersResponse>> getParameter(String key, String bucket, {String? profile, int? version}) {
    var request = GetParameterRequest(key, bucket, profile, version);
    return Process.run("aws", request.args).then((result) => _handleResponse(result, successAction: (d) => GetParametersResponse.fromJson(d, request))).catchError((result) => _handleError(result));
  }

  Future<ResponseWrapper<GetParameterHistoryResponse>> getParameterHistory(String key, String bucket, {String? profile}) {
    var request = GetParameterHistoryRequest(key, bucket, profile);
    return Process.run("aws", request.args)
        .then((result) => _handleResponse(result, successAction: (d) => GetParameterHistoryResponse.fromJson(d, request)))
        .catchError((result) => _handleError(result));
  }

  Future<ResponseWrapper<GetParametersByPathResponse>> getParametersByPath(String key, String bucket, {String? profile, bool recursive = false}) {
    var request = GetParametersByPathRequest(key, bucket, profile, recursive);
    return Process.run("aws", request.args)
        .then((result) => _handleResponse(result, successAction: (d) => GetParametersByPathResponse.fromJson(d, request)))
        .catchError((result) => _handleError(result));
  }

  Future<void> deleteParameter(String key, String bucket, {String? profile}) {
    var request = DeleteParameterRequest(key, bucket, profile);
    return Process.run("aws", request.args).then((result) => _handleResponse(result, successAction: (d) {})).catchError((result) => _handleError(result));
  }

  _handleError(ProcessException exception) {
    AWSException e = AWSException(exception.toString());
    if (exception.message.contains("No such file or directory")) {
      e = AWSBinaryNotFoundException(exception.toString());
    }
    FLog.error(text: "An error occurred", exception: e);
    throw e;
  }

  T _handleResponse<T>(ProcessResult result, {T Function(Map<String, dynamic>)? successAction}) {
    if ((result.stdout as String).isEmpty && (result.stderr as String).isNotEmpty) {
      final e = _generateExceptionFromStdErr(result.stderr);
      FLog.error(text: "An error occurred when requesting aws", exception: e);
      throw e;
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
    if (stderr.contains("No such file or directory")) return AWSBinaryNotFoundException(stderr);
    return AWSException(stderr);
  }
}
