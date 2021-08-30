// /cf-broker/38aca487-aa32-4575-876e-898f7489c993/application_local/server.port
// |                  root                        |      context    | property |
// |                  root                        |               key          |

abstract class AbstractRequest {
  final String _key;
  final String bucket;
  final String? profile;

  AbstractRequest(this._key, this.bucket, this.profile);

  String get key {
    var key = _key;
    if (key.startsWith("/")) {
      key = key.substring(1);
    }
    return [bucket, key].join("/");
  }

  List<String> get args => [
        "ssm",
        command,
        ...locationArgs,
        ...additionalArgs,
        if (profile != null) ...["--profile", profile!]
      ];

  List<String> get locationArgs;

  List<String> get additionalArgs => [];

  String get command;
}

abstract class ByNameRequest extends AbstractRequest {
  ByNameRequest(String key, String bucket, String? profile) : super(key, bucket, profile);

  @override
  List<String> get locationArgs => ["--name", key];
}

abstract class ByPathRequest extends AbstractRequest {
  ByPathRequest(String key, String bucket, String? profile) : super(key, bucket, profile);

  @override
  List<String> get locationArgs => ["--path", key];
}

class PutParameterRequest extends ByNameRequest {
  final String value;

  PutParameterRequest(String key, this.value, String bucket, String? profile) : super(key, bucket, profile);

  @override
  String get command => "put-parameter";

  @override
  List<String> get additionalArgs => ["--type", "String", "--value", value, "--overwrite"];
}

class GetParameterRequest extends ByNameRequest {
  final int? version;

  GetParameterRequest(String key, String bucket, String? profile, this.version) : super(key, bucket, profile);

  @override
  String get key {
    var key = super.key;
    if (version != null) {
      key = "$key:$version";
    }
    return key;
  }

  @override
  String get command => "get-parameters";
}

class GetParameterHistoryRequest extends ByNameRequest {
  GetParameterHistoryRequest(String key, String bucket, String? profile) : super(key, bucket, profile);

  @override
  String get command => "get-parameter-history";
}

class GetParametersByPathRequest extends ByPathRequest {
  final bool recursive;

  GetParametersByPathRequest(String key, String bucket, String? profile, this.recursive) : super(key, bucket, profile);

  @override
  String get command => "get-parameters-by-path";

  @override
  List<String> get additionalArgs => recursive ? ["--recursive"] : [];
}

class DeleteParameterRequest extends ByNameRequest {
  DeleteParameterRequest(String key, String bucket, String? profile) : super(key, bucket, profile);

  @override
  String get command => "delete-parameter";
}
