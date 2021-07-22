part of 'app_bar_context_cubit.dart';

abstract class AppBarContextState extends Equatable {
  const AppBarContextState();

  bool get loading;

  AppBarContextState withLoading(bool loading);
}

abstract class AbstractParameter {
  String? get bucket;
  String? get profile;
  String? get app;
}

class ParameterNotAvailable extends AppBarContextState implements AbstractParameter{
  const ParameterNotAvailable({
    this.loading = false,
    this.bucket,
    this.profile,
    this.app,
  });

  @override
  final bool loading;
  @override
  final String? bucket;
  @override
  final String? profile;
  @override
  final String? app;

  @override
  List<Object?> get props => [loading, bucket, profile, app];

  @override
  ParameterNotAvailable withLoading(bool loading) {
    return ParameterNotAvailable(loading: loading, bucket: bucket, profile: profile, app: app);
  }
}

class ParameterAvailable extends AppBarContextState implements AbstractParameter{
  const ParameterAvailable({
    this.loading = false,
    required this.modified,
    required this.bucket,
    required this.profile,
    required this.app,
    required this.property,
    required this.value,
  });

  @override
  final bool loading;
  final bool modified;
  @override
  final String bucket;
  @override
  final String profile;
  @override
  final String app;
  final String property;
  final String value;

  @override
  List<Object?> get props => [loading, modified, bucket, profile, app, property, value];

  @override
  ParameterAvailable withLoading(bool loading) {
    return ParameterAvailable(
      loading: loading,
      modified: modified,
      bucket: bucket,
      profile: profile,
      app: app,
      property: property,
      value: value,
    );
  }
}
