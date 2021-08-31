import 'package:aws_parameter_store/service/service_locator.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/column_view.dart';
import 'package:aws_parameter_store/ui/setup_screen/widgets/setup_list/setup_list.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../main.dart';

part 'save_button_state.dart';

class SaveButtonContext extends Cubit<SaveButtonContextState> {
  SaveButtonContext() : super(const SaveButtonContextState(false));

  final SetupListContext setupList = sl<SetupListContext>();

  void refresh(bool valid) {
    emit(SaveButtonContextState(valid));
  }

  void onPressed(BuildContext context) async {
    final items = await sl<SetupListContext>().saveAllItems();

    ServiceLocator.setHomeDependencies();

    sl<ColumnViewContext>().loadFirstOf(items.map((e) => e.key.currentState!.bucketNameController.text).toList());

    Navigator.pushReplacementNamed(context, "/home");
  }
}
