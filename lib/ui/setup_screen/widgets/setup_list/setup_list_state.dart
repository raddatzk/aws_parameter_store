part of 'setup_list_cubit.dart';

class SetupItemWithKey {
  final SetupItem item;
  final GlobalKey<SetupItemState> key;

  SetupItemWithKey(this.item, this.key);
}

class SetupListContextState {
  const SetupListContextState(this.items);

  final List<SetupItemWithKey> items;
}
