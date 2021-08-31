part of 'app_bar_cubit.dart';

class AwsAppBarContextState extends Equatable {
  const AwsAppBarContextState(this.loading, this.modified);

  final bool loading;
  final bool? modified;

  @override
  List<Object?> get props => [loading, modified];

  AwsAppBarContextState withLoading(bool loading) {
    return AwsAppBarContextState(loading, modified);
  }

  AwsAppBarContextState withModified(bool? modified) {
    return AwsAppBarContextState(loading, modified);
  }
}
