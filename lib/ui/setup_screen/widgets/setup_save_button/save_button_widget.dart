import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import 'save_button_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveButtonContext, SaveButtonContextState>(
      bloc: sl<SaveButtonContext>(),
      builder: (context, state) {
        return FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: state.allItemsInitialized ? () => sl<SaveButtonContext>().onPressed(context) : null,
        );
      },
    );
  }
}
