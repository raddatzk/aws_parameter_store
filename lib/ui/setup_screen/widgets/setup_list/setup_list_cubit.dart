import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:aws_parameter_store/ui/setup_screen/widgets/setup_list/widgets/setup_item.dart';
import 'package:aws_parameter_store/ui/setup_screen/widgets/setup_save_button/save_button.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../../../main.dart';

part 'setup_list_state.dart';

class SetupListContext extends Cubit<SetupListContextState> {
  SetupListContext() : super(SetupListContextState(<SetupItemWithKey>[].toList()));

  void addItem(SetupItemWithKey item) {
    emit(SetupListContextState(state.items..add(item)));
  }

  void setItems(List<SetupItemWithKey> items) {
    emit(SetupListContextState(items));
  }

  void deleteItem(SetupItem item) {
    var newState = SetupListContextState(state.items..removeWhere((element) => element.item == item));
    refresh();
    emit(newState);
  }

  void refresh() {
    if (state.items.isEmpty) {
      sl<SaveButtonContext>().refresh(false);
    } else {
      sl<SaveButtonContext>().refresh(state.items.every((element) => element.key.currentState!.complete()));
    }
  }

  Future<List<SetupItemWithKey>> saveAllItems() async {
    await sl<PreferencesRepository>().clear();
    for (var item in state.items) {
      final currentState = item.key.currentState!;
      sl<PreferencesRepository>().setBucketFor(currentState.bucketNameController.text, Bucket(currentState.bucketUrlController.text, currentState.awsProfileController.text));
    }

    return state.items;
  }
}
