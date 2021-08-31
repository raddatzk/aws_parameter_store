part of 'add_button_cubit.dart';

class AddButtonState extends Equatable {
  final String? bucket;
  final String? profile;
  final String? app;

  const AddButtonState({this.bucket, this.profile, this.app});

  @override
  List<Object?> get props => [bucket, profile, app];
}
