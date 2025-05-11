import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ========================
// Data Containers
// ========================

/// For 2 selected values
class Data2<T1, T2> {
  final T1 v1;
  final T2 v2;

  const Data2(this.v1, this.v2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Data2 && runtimeType == other.runtimeType && v1 == other.v1 && v2 == other.v2;

  @override
  int get hashCode => v1.hashCode ^ v2.hashCode;
}

/// For 3 selected values
class Data3<T1, T2, T3> {
  final T1 v1;
  final T2 v2;
  final T3 v3;

  const Data3(this.v1, this.v2, this.v3);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Data3 && runtimeType == other.runtimeType && v1 == other.v1 && v2 == other.v2 && v3 == other.v3;

  @override
  int get hashCode => v1.hashCode ^ v2.hashCode ^ v3.hashCode;
}

// ========================
// Typedefs
// ========================

typedef Select2<S, T1, T2> = Data2<T1, T2> Function(S state);
typedef Select3<S, T1, T2, T3> = Data3<T1, T2, T3> Function(S state);

typedef Build2<T1, T2> = Widget Function(BuildContext context, T1 v1, T2 v2);
typedef Build3<T1, T2, T3> = Widget Function(BuildContext context, T1 v1, T2 v2, T3 v3);

// ========================
// Widgets
// ========================

/// Selects 2 values from bloc state
class BlocData2<B extends StateStreamable<S>, S, T1, T2> extends StatelessWidget {
  final Select2<S, T1, T2> selector;
  final Build2<T1, T2> builder;

  const BlocData2({super.key, required this.selector, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, Data2<T1, T2>>(
      selector: selector,
      builder: (context, data) => builder(context, data.v1, data.v2),
    );
  }
}

/// Selects 3 values from bloc state
class BlocData3<B extends StateStreamable<S>, S, T1, T2, T3> extends StatelessWidget {
  final Select3<S, T1, T2, T3> selector;
  final Build3<T1, T2, T3> builder;

  const BlocData3({super.key, required this.selector, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, Data3<T1, T2, T3>>(
      selector: selector,
      builder: (context, data) => builder(context, data.v1, data.v2, data.v3),
    );
  }
}
