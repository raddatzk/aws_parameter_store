import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DualBlocBuilder<B1 extends BlocBase<S1>, S1, B2 extends BlocBase<S2>, S2> extends StatefulWidget {
  const DualBlocBuilder({Key? key, required this.bloc1, required this.bloc2, required this.builder}): super(key: key);

  final B1 bloc1;
  final B2 bloc2;
  final Widget Function(BuildContext context, S1 s1, S2 s2) builder;

  @override
  State<StatefulWidget> createState() => _DualBlocBuilder();

}

class _DualBlocBuilder<B1 extends BlocBase<S1>, S1, B2 extends BlocBase<S2>, S2> extends State<DualBlocBuilder<B1, S1, B2, S2>>{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S1>(
      bloc: widget.bloc1,
      builder: (context, s1) {
        return BlocBuilder<B2, S2>(
          bloc: widget.bloc2,
          builder: (context, s2) {
            return widget.builder(context, s1, s2);
          }
        );
      }
    );
  }
}