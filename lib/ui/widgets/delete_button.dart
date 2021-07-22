import 'package:aws_parameter_store/bloc/app_bar_context/app_bar_context_cubit.dart';
import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key, required this.state}) : super(key: key);

  final ParameterAvailable state;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Icon(Icons.delete),
      onPressed: () => sl<ApplicationContext>().delete(state.bucket, state.profile, state.app, state.property),
    );
  }
}
