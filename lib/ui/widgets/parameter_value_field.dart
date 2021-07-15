import 'package:flutter/material.dart';

class ParameterValueField extends StatefulWidget {
  final String initialValue;
  final void Function(String) onChanged;

  const ParameterValueField({Key? key, required this.initialValue, required this.onChanged}) : super(key: key);

  @override
  State<ParameterValueField> createState() => _ParameterValueFieldState();
}

class _ParameterValueFieldState extends State<ParameterValueField> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue)
      ..addListener(() => widget.onChanged(_controller.text));
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: IntrinsicWidth(
        child: TextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            fillColor: Colors.grey,
            filled: true,
          ),
          keyboardType: TextInputType.multiline,
          controller: _controller,
          maxLines: null,
        ),
      ),
    );
  }
}
