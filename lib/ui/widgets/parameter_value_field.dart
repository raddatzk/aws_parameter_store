import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';

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
    return BlocBuilder<ScrollHandler, ScrollHandlerState>(
      bloc: sl<ScrollHandler>(),
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: state.scrollParameter ? null : const NeverScrollableScrollPhysics(),
          child: MouseRegion(
            onHover: (_) => sl<ScrollHandler>().hoverOnParameter(),
            onEnter: (_) => sl<ScrollHandler>().enterParameter(),
            onExit: (_) => sl<ScrollHandler>().exitParameter(),
            child: IntrinsicWidth(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 560),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "value",
                  ),
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  maxLines: null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
