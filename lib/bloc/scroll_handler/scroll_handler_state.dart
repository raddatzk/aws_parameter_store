part of 'scroll_handler_cubit.dart';

class ScrollHandlerState extends Equatable {
  const ScrollHandlerState(this.scrollOverview, this.scrollParameter);

  final bool scrollOverview;
  final bool scrollParameter;

  @override
  List<Object> get props => [scrollOverview, scrollParameter];
}
