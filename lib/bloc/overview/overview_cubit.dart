// import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
// import 'package:aws_parameter_store/repository/aws_repository.dart';
// import 'package:bloc/bloc.dart';
// import 'package:collection/collection.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';
//
// import '../../main.dart';
//
// part 'overview_state.dart';
//
// class OverviewCubit extends Cubit<OverviewState> {
//   OverviewCubit() : super(const OverviewInitial());
//
//   final AWSRepository repository = sl<AWSRepository>();
//   final ParameterActions propertyCubit = sl<ParameterActions>();
//
//   Future<Map<String, Map<String, List<GetParametersByPathResponse>>>> getParametersByPath() async {
//     var response = (await repository.getParametersByPath(SimpleParameter("/")));
//     final groupedByProfile = groupBy(response.parameters, (e) => (e as GetParametersByPathResponse).profile);
//     final profileMap = <String, Map<String, List<GetParametersByPathResponse>>>{};
//     for (final entry in groupedByProfile.entries) {
//       profileMap.putIfAbsent(entry.key, () => groupBy(entry.value, (e) => (e).appName));
//     }
//
//     return profileMap;
//   }
//
//   Future<void> initialize() async {
//     final profileMap = await getParametersByPath();
//
//     if (state is ContextPrepared) {
//       final String? selectedProfile = (state as ContextPrepared).selectedProfile;
//       final String? selectedApp = (state as ContextPrepared).selectedApp;
//       final String? selectedProperty = (state as ContextPrepared).selectedProperty;
//
//       if (profileMap[selectedProfile] == null) {
//         _refreshWithData(profileMap);
//       }
//       if (profileMap[selectedProfile]![selectedApp] == null) {
//         _refreshWithData(
//           profileMap,
//           selectedProfile: selectedProfile,
//         );
//       }
//       if (profileMap[selectedProfile]![selectedApp]!.where((element) => element.property == selectedProperty).isEmpty) {
//         _refreshWithData(
//           profileMap,
//           selectedProfile: selectedProfile,
//           selectedApp: selectedApp,
//         );
//       }
//       if (profileMap[selectedProfile]![selectedApp]!.where((element) => element.property == selectedProperty).isNotEmpty) {
//         _refreshWithData(
//           profileMap,
//           selectedProfile: selectedProfile,
//           selectedApp: selectedApp,
//           selectedProperty: selectedProperty,
//         );
//       }
//     } else {
//       _refreshWithData(profileMap);
//     }
//   }
//
//   void _refreshWithData(Map<String, Map<String, List<GetParametersByPathResponse>>> data, {String? selectedProfile, String? selectedApp, String? selectedProperty}) {
//     emit(ContextPrepared(
//       data,
//       selectedProfile: selectedProfile,
//       selectedApp: selectedApp,
//       selectedProperty: selectedProperty,
//     ));
//   }
//
//   void refresh({String? selectedProfile, String? selectedApp, String? selectedProperty}) {
//     final lastState = (state as ContextPrepared);
//     _refreshWithData(
//       lastState.data,
//       selectedProfile: selectedProfile,
//       selectedApp: selectedApp,
//       selectedProperty: selectedProperty,
//     );
//   }
//
//   Future<void> add(String profile, String app, String property) async {
//     sl<ParameterActions>().reset();
//     String name = "";
//     if (app == "all applications") {
//       name = "application";
//     } else {
//       name = app;
//     }
//     if (profile != "all profiles") {
//       name = "${name}_${profile.replaceAll(" profile", "")}";
//     }
//     name = "$name/$property";
//     await repository.putParameter(KeyValueParameter(name, "change me"));
//
//     final response = await getParametersByPath();
//     _refreshWithData(response, selectedProfile: profile, selectedApp: app, selectedProperty: property);
//     sl<ParameterActions>().load(name);
//   }
// }
