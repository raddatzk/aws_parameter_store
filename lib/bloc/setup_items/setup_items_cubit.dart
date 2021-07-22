import 'package:aws_parameter_store/bloc/app_bar_context/app_bar_context_cubit.dart';
import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/bloc/setup_is_valid/setup_is_valid_cubit.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:aws_parameter_store/ui/widgets/setup_item.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_aws_parameter_store/flutter_aws_parameter_store.dart';

import '../../main.dart';

part 'setup_items_state.dart';

class SetupItemWithKey {
  final SetupItem item;
  final GlobalKey<SetupItemState> key;

  SetupItemWithKey(this.item, this.key);
}

class SetupItemsCubit extends Cubit<SetupItemsState> {
  SetupItemsCubit() : super(SetupItemsState(<SetupItemWithKey>[].toList()));

  void addItem(SetupItemWithKey item) {
    emit(SetupItemsState(state.items..add(item)));
  }

  void setItems(List<SetupItemWithKey> items) {
    emit(SetupItemsState(items));
  }

  void deleteItem(SetupItem item) {
    sl<PreferencesRepository>().deleteBucket(item.bucketName!);
    var newState = SetupItemsState(state.items..removeWhere((element) => element.item == item));
    refresh();
    emit(newState);
  }

  void refresh() {
    if (state.items.isEmpty) {
      sl<SetupIsValidCubit>().refresh(false);
    } else {
      sl<SetupIsValidCubit>().refresh(state.items.every((element) => element.key.currentState!.complete()));
    }
  }

  void saveAllAndGoToHome() async {
    await sl<PreferencesRepository>().clear();
    for (var item in state.items) {
      final currentState = item.key.currentState!;
      sl<PreferencesRepository>().setBucketFor(currentState.bucketNameController.text, Bucket(currentState.bucketUrlController.text, currentState.awsProfileController.text));
    }
    final awsParameterStore = AWSParameterStore();
    sl.registerSingleton<AWSRepository>(AWSRepository(awsParameterStore));
    sl.registerSingleton<ScrollHandler>(ScrollHandler());

    sl.registerSingleton<AppBarContext>(AppBarContext());
    sl.registerSingleton<ApplicationContextParameterService>(ApplicationContextParameterService());
    var context = ApplicationContext();
    sl.registerSingleton<ApplicationContext>(context);

    context.loadFirstOf(state.items.map((e) => e.key.currentState!.bucketNameController.text).toList());

  }
}
