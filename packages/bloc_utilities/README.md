<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# BLoC Utilities Package

A collection of utility widgets and classes to simplify working with the [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) package, providing
enhanced functionality for common BLoC patterns.

## Features

* **Multi-Value Selectors:** Select multiple values from BLoC state in a single widget for more efficient UI updates.
* **Selector-Listener Combinations:** Combine the power of state selection with reactive listeners in a single, concise widget.
* **Nested Selectors:** Chain selectors to perform complex transformations and access deeply nested values within your BLoC state.
* **Parallel Selectors:** Select multiple, independent values from the same BLoC concurrently for optimized data retrieval.
* **Type-Safe Data Containers:** Utilize convenient, type-safe containers to manage and access multiple selected values with improved code clarity and
  safety.