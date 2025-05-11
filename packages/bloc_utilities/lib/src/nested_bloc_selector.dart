import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef NestedBlocWidgetBuilder<S1, S2> = Widget Function(BuildContext context, S1 state1, S2 state2);

class NestedBlocSelector<B extends StateStreamable<S>, S, T1, T2> extends StatelessWidget {
  final BlocWidgetSelector<S, T1> firstSelector;
  final BlocWidgetSelector<T1, T2> secondSelector;
  final NestedBlocWidgetBuilder<T1, T2> builder;

  const NestedBlocSelector({
    super.key,
    required this.firstSelector,
    required this.secondSelector,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, T1>(
      selector: firstSelector,
      builder: (context, firstState) {
        return BlocSelector<StateStreamable<T1>, T1, T2>(
          selector: secondSelector,
          builder: (context, secondState) {
            return builder(context, firstState, secondState);
          },
        );
      },
    );
  }
}
