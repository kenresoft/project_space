import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A container for 2 selected values from bloc state
class SelectedValues2<T1, T2> {
  final T1 value1;
  final T2 value2;

  SelectedValues2(this.value1, this.value2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedValues2 && runtimeType == other.runtimeType && value1 == other.value1 && value2 == other.value2;

  @override
  int get hashCode => value1.hashCode ^ value2.hashCode;
}

/// A container for 3 selected values from bloc state
class SelectedValues3<T1, T2, T3> {
  final T1 value1;
  final T2 value2;
  final T3 value3;

  SelectedValues3(this.value1, this.value2, this.value3);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedValues3 &&
          runtimeType == other.runtimeType &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3;

  @override
  int get hashCode => value1.hashCode ^ value2.hashCode ^ value3.hashCode;
}

/// Builder typedefs
typedef MultiBlocWidgetBuilder2<T1, T2> = Widget Function(BuildContext context, T1 value1, T2 value2);

typedef MultiBlocWidgetBuilder3<T1, T2, T3> = Widget Function(BuildContext context, T1 value1, T2 value2, T3 value3);

/// Selector typedefs
typedef BlocWidgetSelector2<S, T1, T2> = SelectedValues2<T1, T2> Function(S state);
typedef BlocWidgetSelector3<S, T1, T2, T3> = SelectedValues3<T1, T2, T3> Function(S state);

/// For selecting 2 values from bloc state
class BlocMultiSelector2<B extends StateStreamable<S>, S, T1, T2> extends StatelessWidget {
  final BlocWidgetSelector2<S, T1, T2> selector;
  final MultiBlocWidgetBuilder2<T1, T2> builder;

  const BlocMultiSelector2({super.key, required this.selector, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, SelectedValues2<T1, T2>>(
      selector: selector,
      builder: (context, values) {
        return builder(context, values.value1, values.value2);
      },
    );
  }
}

/// For selecting 3 values from bloc state
class BlocMultiSelector3<B extends StateStreamable<S>, S, T1, T2, T3> extends StatelessWidget {
  final BlocWidgetSelector3<S, T1, T2, T3> selector;
  final MultiBlocWidgetBuilder3<T1, T2, T3> builder;

  const BlocMultiSelector3({super.key, required this.selector, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, SelectedValues3<T1, T2, T3>>(
      selector: selector,
      builder: (context, values) {
        return builder(context, values.value1, values.value2, values.value3);
      },
    );
  }
}
