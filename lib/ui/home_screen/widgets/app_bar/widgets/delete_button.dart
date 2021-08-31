import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/parameter_column/parameter_column.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Icon(Icons.delete),
      onPressed: () => sl<ParameterColumnContext>().delete(),
    );
  }
}
