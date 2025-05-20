/*
// responsive_helpers.dart improvements
import 'package:flutter/widgets.dart';

/// Helper utilities for common EdgeInsets patterns
class EdgeInsetsExt {
  // Prevent instantiation
  EdgeInsetsExt._();

  /// Create horizontal symmetric padding
  static EdgeInsets wSymmetric({required double horizontal}) =>
      EdgeInsets.symmetric(horizontal: horizontal);

  /// Create vertical symmetric padding
  static EdgeInsets hSymmetric({required double vertical}) => EdgeInsets.symmetric(vertical: vertical);

  /// Create all-sides padding
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Create top-only padding
  static EdgeInsets onlyTop(double value) => EdgeInsets.only(top: value);

  /// Create bottom-only padding
  static EdgeInsets onlyBottom(double value) => EdgeInsets.only(bottom: value);

  /// Create left-only padding
  static EdgeInsets onlyLeft(double value) => EdgeInsets.only(left: value);

  /// Create right-only padding
  static EdgeInsets onlyRight(double value) => EdgeInsets.only(right: value);

  /// Create directional padding accounting for text direction
  static EdgeInsetsDirectional directional({
    double start = 0.0,
    double end = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  }) => EdgeInsetsDirectional.fromSTEB(start, top, end, bottom);
}

/// Helper class to define static dimension constants
class AppDimensions {
  // Prevent instantiation
  AppDimensions._();

  // Spacing scale
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Component dimensions
  static const double buttonHeight = 48.0;
  static const double cardBorderRadius = 16.0;
  static const double inputFieldHeight = 56.0;
  static const double bottomNavHeight = 56.0;
  static const double appBarHeight = 56.0;

  // Typography
  static const double bodyText = 14.0;
  static const double smallText = 12.0;
  static const double headline = 24.0;
  static const double title = 18.0;
  static const double subtitle = 16.0;
  static const double caption = 10.0;
}
*/
