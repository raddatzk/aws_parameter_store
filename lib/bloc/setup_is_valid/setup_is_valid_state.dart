part of 'setup_is_valid_cubit.dart';

class SetupIsValidState extends Equatable {
  const SetupIsValidState(this.allItemsInitialized);

  final bool allItemsInitialized;

  @override
  List<Object?> get props => [allItemsInitialized];
}