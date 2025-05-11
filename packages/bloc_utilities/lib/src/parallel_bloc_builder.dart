import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ParallelBlocWidgetBuilder<S1, S2> = Widget Function(BuildContext context, S1 state1, S2 state2);

class ParallelBlocBuilder<B1 extends StateStreamable<S1>, B2 extends StateStreamable<S2>, S1, S2>
    extends StatelessWidget {
  final ParallelBlocWidgetBuilder<S1, S2> builder;

  const ParallelBlocBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S1>(
      builder: (context, firstState) {
        return BlocBuilder<B2, S2>(
          builder: (context, secondState) {
            return builder(context, firstState, secondState);
          },
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ParallelBlocWidgetBuilder<S1, S2>>.has('builder', builder));
  }
}
