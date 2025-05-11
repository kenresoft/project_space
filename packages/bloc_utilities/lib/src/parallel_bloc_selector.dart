import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'parallel_bloc_builder.dart';

class ParallelBlocSelector<B extends StateStreamable<S>, S, T1, T2> extends StatelessWidget {
  final BlocWidgetSelector<S, T1> firstSelector;
  final BlocWidgetSelector<S, T2> secondSelector;
  final ParallelBlocWidgetBuilder<T1, T2> builder;

  const ParallelBlocSelector({
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
        return BlocSelector<B, S, T2>(
          selector: secondSelector,
          builder: (context, secondState) {
            return builder(context, firstState, secondState);
          },
        );
      },
    );
  }
}
