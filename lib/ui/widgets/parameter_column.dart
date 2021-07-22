import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:aws_parameter_store/ui/widgets/information_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'parameter_value_field.dart';

class ParameterColumn extends StatefulWidget {
  const ParameterColumn({Key? key, required this.state}) : super(key: key);

  final ApplicationContextPrepared state;

  @override
  State<ParameterColumn> createState() => _ParameterColumnState();
}

class _ParameterColumnState extends State<ParameterColumn> {
  late final int initialVersion;
  late int currentVersion;

  @override
  void initState() {
    super.initState();
    currentVersion = widget.state.parameter!.data.length;
    initialVersion = currentVersion;
  }

  @override
  Widget build(BuildContext context) {
    final versionedParameter = widget.state.parameter!.data[currentVersion - 1];

    return SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  versionedParameter.property,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "version: ",
                    ),
                    DropdownButton<int>(
                        value: currentVersion,
                        items: widget.state.parameter!.data
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e.version,
                                child: Text(
                                  e.version.toString(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          sl<ApplicationContext>().changedVersion(value!, value != initialVersion);
                          setState(() => currentVersion = value);
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ParameterValueField(
                  key: GlobalKey(),
                  initialValue: versionedParameter.value,
                  onChanged: sl<ApplicationContext>().updateDraft,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InformationText(title: "bucket", value: versionedParameter.bucket),
                    InformationText(title: "profile", value: versionedParameter.profile),
                    InformationText(title: "app", value: versionedParameter.app),
                    InformationText(title: "property", value: versionedParameter.property),
                    InformationText(title: "version", value: versionedParameter.version.toString()),
                    InformationText(title: "last modified at", value: versionedParameter.lastModifiedDate?.toIso8601String() ?? "-"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
