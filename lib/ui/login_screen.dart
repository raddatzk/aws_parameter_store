import 'package:aws_parameter_store/bloc/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final cubit = sl<LoginCubit>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      bloc: cubit,
      listener: (context, state) {
        Navigator.pushReplacementNamed(context, "/home");
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("login")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              controller: controller,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => cubit.loginWithCloudfoundryJson(controller.text),
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
