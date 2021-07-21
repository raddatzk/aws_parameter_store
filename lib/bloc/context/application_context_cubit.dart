import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';

part 'application_context_state.dart';

class ApplicationContext extends Cubit<ApplicationContextState> {
  ApplicationContext() : super(const ApplicationContextInitial());

  final AWSRepository repository = sl<AWSRepository>();

  Map<String, Map<String, Map<String, List<GetParametersByPathResponse>>>?> data = {};

  ApplicationContextPrepared get lastState => (super.state as ApplicationContextPrepared);

  void reloadCurrentPath(String selectedBucket, {String? selectedProfile, String? selectedApp, String? selectedProperty}) {
    if (data[selectedBucket] == null) {
      initialize(selectedBucket);
    }
    if (lastState.draft) {
      _removeCurrentSelected();
    }
    emit(ApplicationContextPrepared(
      data,
      currentBucket: selectedBucket,
      currentProfile: selectedProfile,
      currentApp: selectedApp,
      currentProperty: selectedProperty,
    ));
  }

  Future<Map<String, Map<String, List<GetParametersByPathResponse>>>> _getParametersByPath(String bucketName) async {
    var response = (await repository.getParametersByPath("", bucketName));
    final groupedByProfile = groupBy(response.parameters, (e) => (e as GetParametersByPathResponse).profile);
    final profileMap = <String, Map<String, List<GetParametersByPathResponse>>>{};
    for (final entry in groupedByProfile.entries) {
      profileMap.putIfAbsent(entry.key, () => groupBy(entry.value, (e) => (e).appName));
    }

    return profileMap;
  }

  void initializeFirstOf(List<String> bucketNames) async {
    data = {for (var bucketName in bucketNames) bucketName: null};
    data[bucketNames.first] = await _getParametersByPath(bucketNames.first);
    emit(ApplicationContextPrepared(
      data,
      currentBucket: bucketNames.first,
    ));
  }

  void initialize(String bucketName) async {
    data[bucketName] = await _getParametersByPath(bucketName);
    data = Map.of(data);
  }

  void initializeCurrentBucket() async {
    final lastBucket = lastState.currentBucket!;
    data[lastBucket] = await _getParametersByPath(lastBucket);
    data = Map.of(data);
    emit(ApplicationContextPrepared(
      data,
      currentBucket: lastBucket,
      currentProfile: lastState.currentProfile,
      currentApp: lastState.currentApp,
      currentProperty: lastState.currentProperty,
    ));
  }

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
    return "$name/$property";
  }

  void addDraft(String profile, String app, String property) {
    final currentBucket = data[lastState.currentBucket]!;
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
      currentApp.add(repository.getDraftParameterByPath(_generateName(profile, app, property), lastState.currentBucket!));
    }

    sl<ParameterActions>().addDraft(lastState.currentBucket!, profile, app, property);

    emit(ApplicationContextPrepared(
      data,
      currentBucket: lastState.currentBucket!,
      currentProfile: profile,
      currentApp: app,
      currentProperty: property,
      draft: true,
    ));
  }

  void _removeCurrentSelected() {
    var currentBucket = lastState.currentBucket!;
    var currentProfile = lastState.currentProfile!;
    var currentApp = lastState.currentApp!;
    var currentProperty = lastState.currentProperty!;

    final profiles = lastState.data[currentBucket]!;
    final apps = lastState.data[currentBucket]![currentProfile]!;
    final properties = lastState.data[currentBucket]![currentProfile]![currentApp]!;

    properties.removeWhere((element) => element.property == currentProperty);
    if (properties.isEmpty) {
      apps.remove(currentApp);
      if (apps.keys.isEmpty) {
        profiles.remove(currentProfile);
        if (profiles.isNotEmpty) {
          currentProfile = profiles.keys.first;
        }
      } else {
        currentApp = apps.keys.first;
      }
    } else {
      currentProperty = properties.first.property;
    }
  }

  void removeCurrentSelected() {
    var currentBucket = lastState.currentBucket!;
    var currentProfile = lastState.currentProfile!;
    var currentApp = lastState.currentApp!;

    final profiles = lastState.data[currentBucket]!;
    final apps = lastState.data[currentBucket]![currentProfile]!;
    final properties = lastState.data[currentBucket]![currentProfile]![currentApp]!;

    _removeCurrentSelected();

    if (data[currentBucket]![currentProfile]!.isEmpty) {
      emit(ApplicationContextPrepared(
        data,
        currentBucket: currentBucket,
        currentProfile: profiles.keys.first,
        currentApp: null,
        currentProperty: null,
      ));
    } else if (data[currentBucket]![currentProfile]![currentApp]!.isEmpty) {
      emit(ApplicationContextPrepared(
        data,
        currentBucket: currentBucket,
        currentProfile: currentProfile,
        currentApp: apps.keys.first,
        currentProperty: null,
      ));
    } else {
      emit(ApplicationContextPrepared(
        data,
        currentBucket: currentBucket,
        currentProfile: currentProfile,
        currentApp: currentApp,
        currentProperty: null,
      ));
    }
  }

  void removeDraftStatus() {
    emit(ApplicationContextPrepared(
      lastState.data,
      currentBucket: lastState.currentBucket,
      currentProfile: lastState.currentProfile,
      currentApp: lastState.currentApp,
      currentProperty: lastState.currentProperty,
    ));
  }
}
