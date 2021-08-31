import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/parameter_column/widget/information_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import 'parameter_column.dart';
import 'widget/parameter_value_field.dart';

class ParameterColumn extends StatefulWidget {
  const ParameterColumn({Key? key, required this.state}) : super(key: key);

  final ParameterColumnState state;

  @override
  State<ParameterColumn> createState() => _ParameterColumnState();
}

class _ParameterColumnState extends State<ParameterColumn> {
  late final int initialVersion;
  late int currentVersion;

  @override
  void initState() {
    super.initState();
    currentVersion = widget.state.content!.data.length;
    initialVersion = currentVersion;
  }

  @override
  Widget build(BuildContext context) {
    final versionedParameter = widget.state.content!.data[currentVersion - 1];

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
                      value: versionedParameter.version == 0 ? 0 : currentVersion,
                      items: widget.state.content!.data
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
                        // sl<ParameterColumnContext>().changedVersionTo(value!, value != initialVersion);
                        setState(() => currentVersion = value!);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ParameterValueField(
                  key: GlobalKey(),
                  initialValue: versionedParameter.value,
                  onChanged: sl<ParameterColumnContext>().updateValueWith,
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
