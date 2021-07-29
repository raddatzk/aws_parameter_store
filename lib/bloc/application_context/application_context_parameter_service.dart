part of 'application_context_cubit.dart';

class ApplicationContextParameterService {

  final AWSRepository repository = sl<AWSRepository>();

  ParameterContentWrapper? state;

  String currentValue = "";

  bool draft = false;

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

  bool isInCreation() {
    return state != null && state!.version == 0;
  }

  Future<ParameterContentWrapper?> tryToLoadParameter(ContextData data, String bucket, String? profile, String? app, String? property) async {
    if (profile != null && app != null && property != null) {
      return loadParameter(data[bucket]![profile]![app]!.firstWhere((element) => element.property == property).relativeName, bucket, profile, app, property);
    }
  }

  Future<ParameterContentWrapper> loadParameter(String path, String bucket, profile, app, property) async {
    sl<AppBarContext>().startLoading();
    state = ParameterContentWrapper.fromHistory(bucket, await repository.getParameterHistory(path, bucket));
    sl<AppBarContext>().stopLoading();
    currentValue = state!.value;
    sl<AppBarContext>().loadParameter(bucket, profile, app, property, currentValue);

    return state!;
  }

  void updateParameter(String value) {
    if (currentValue != value) {
      draft = true;

      sl<AppBarContext>().updateParameter(true, value);
    } else {
      draft = false;
      sl<AppBarContext>().updateParameter(false, value);
    }
  }

  void addParameter(ParameterContentWrapper parameter) {
    sl<AppBarContext>().loadParameter(parameter.bucket, parameter.profile, parameter.app, parameter.property, parameter.value, modified: true);
    draft = true;
    currentValue = "";
    state = parameter;
  }

  Future<void> saveParameter(String value) async {
    await repository.putParameter(_generateName(state!.profile, state!.app, state!.property), value, state!.bucket);
    draft = false;
  }

  Future<void> deleteParameter() async {
    await repository.deleteParameter(_generateName(state!.profile, state!.app, state!.property), state!.bucket);
    draft = false;
  }

  void cancelParameter() {
    draft = false;
  }

  void changeVersionTo(int version, bool modified) {
    sl<AppBarContext>().changeVersionTo(state!.bucket, state!.profile, state!.app, state!.property, state!.data[version - 1].value, modified);
  }
}