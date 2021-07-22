import 'package:flutter/material.dart';

class InformationText extends StatelessWidget {

  const InformationText({Key? key, required this.title, required this.value}) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return  Row(children: [
      SizedBox(
        width: 130,
        child: Text(
          "$title: ",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 12),
      )
    ]);
  }
}
