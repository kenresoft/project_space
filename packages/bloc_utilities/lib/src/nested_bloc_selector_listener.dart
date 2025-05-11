import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'nested_bloc_selector.dart';

class NestedBlocSelectorListener<B extends StateStreamable<S>, S, T1, T2> extends StatelessWidget {
  final BlocWidgetSelector<S, T1> firstSelector;
  final BlocWidgetSelector<T1, T2> secondSelector;
  final NestedBlocWidgetBuilder<T1, T2> builder;
  final BlocWidgetListener<S> listener;
  final BlocListenerCondition<S>? listenWhen;

  const NestedBlocSelectorListener({
    super.key,
    required this.firstSelector,
    required this.secondSelector,
    required this.builder,
    required this.listener,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: listenWhen,
      listener: listener,
      child: NestedBlocSelector<B, S, T1, T2>(
        firstSelector: firstSelector,
        secondSelector: secondSelector,
        builder: builder,
      ),
    );
  }
}
