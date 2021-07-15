import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import 'parameter_value_field.dart';

class ParameterSettings extends StatefulWidget {
  const ParameterSettings({Key? key}) : super(key: key);

  @override
  State<ParameterSettings> createState() => _ParameterSettingsState();
}

class _ParameterSettingsState extends State<ParameterSettings> {
  String _relativeName = "";
  String _value = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: BlocConsumer<ParameterActions, ParameterActionsState>(
          bloc: sl<ParameterActions>(),
          listener: (context, state) {
            if (state is InitiateSave) {
              sl<ParameterActions>().save(_relativeName, _value);
            }
            if (state is InitiateDelete) {
              sl<ParameterActions>().delete(_relativeName);
            }
          },
          builder: (context, state) {
            if (state is ParameterLoaded) {
              _relativeName = state.response.relativeName;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.response.property,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ParameterValueField(
                        initialValue: state.response.value,
                        onChanged: (value) => _value = value,
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(children: [
                            const Text(
                              "version: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              state.response.version.toString(),
                              style: const TextStyle(fontSize: 12),
                            )
                          ]),
                          Row(
                            children: [
                              const Text(
                                "last modified at: ",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                state.response.lastModifiedDate.toIso8601String(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
