part of 'application_context_cubit.dart';

abstract class ApplicationContextState extends Equatable {
  const ApplicationContextState();
}

class ApplicationContextInitial extends ApplicationContextState {
  const ApplicationContextInitial();

  @override
  List<Object?> get props => [];
}

class ApplicationContextPrepared extends ApplicationContextState {
  final Map<String, Map<String, Map<String, List<GetParametersByPathResponse>>>?> data;
  final String? currentBucket;
  final String? currentProfile;
  final String? currentApp;
  final String? currentProperty;
  final bool draft;

  const ApplicationContextPrepared(this.data, {this.draft = false, this.currentBucket, this.currentProfile, this.currentApp, this.currentProperty});

  @override
  List<Object?> get props => [data, currentBucket, currentProfile, currentApp, currentProperty, draft];
}