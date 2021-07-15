part of 'overview_cubit.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();
}

class OverviewInitial extends OverviewState {
  const OverviewInitial();

  @override
  List<Object?> get props => [];
}

class ContextPrepared extends OverviewState {
  final Map<String, Map<String, List<GetParametersByPathResponse>>> data;

  final String? selectedProfile;
  final String? selectedApp;
  final String? selectedProperty;

  const ContextPrepared(this.data, {this.selectedProfile, this.selectedApp, this.selectedProperty});

  @override
  List<Object?> get props => [data, selectedProfile, selectedApp, selectedProperty];
}