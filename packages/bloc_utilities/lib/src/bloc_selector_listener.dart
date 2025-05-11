import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSelectorListener<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  final BlocWidgetSelector<S, T> selector;
  final BlocWidgetBuilder<T> builder;
  final BlocWidgetListener<S> listener;
  final BlocListenerCondition<S>? listenWhen;

  const BlocSelectorListener({
    super.key,
    required this.selector,
    required this.builder,
    required this.listener,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: listenWhen,
      listener: listener,
      child: BlocSelector<B, S, T>(selector: selector, builder: builder),
    );
  }
}
