part of 'save_button_cubit.dart';

class SaveButtonContextState extends Equatable {
  const SaveButtonContextState(this.allItemsInitialized);

  final bool allItemsInitialized;

  @override
  List<Object?> get props => [allItemsInitialized];
}