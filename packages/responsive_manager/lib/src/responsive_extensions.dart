part of 'responsive_manager.dart';

/// Adds responsive sizing extensions to numeric types
extension ResponsiveNumExtension on num {
  /// Convert to responsive width based on design width
  double get w => ResponsiveManager.globalInstance.scaleWidth(toDouble());

  /// Convert to responsive height based on design height
  double get h => ResponsiveManager.globalInstance.scaleHeight(toDouble());

  /// Convert to responsive font size with system adjustment
  double get sp => ResponsiveManager.globalInstance.scaleFont(toDouble());

  /// Convert to adaptive size based on both width and height ratio
  double get r => ResponsiveManager.globalInstance.adaptiveScale(toDouble());

  /// Get responsive radius
  Radius get radius => Radius.circular(r);

  /// Get responsive circular border radius
  BorderRadius get borderRadius => BorderRadius.circular(r);

  /// Screen width percentage (1.sw = 100% of screen width)
  double get sw => ResponsiveManager.globalInstance.screenSize.width * toDouble();

  /// Screen height percentage (1.sh = 100% of screen height)
  double get sh => ResponsiveManager.globalInstance.screenSize.height * toDouble();
}

extension ResponsiveMinHeightExtension on num {
  /// Convert to responsive height with a minimum value constraint
  /// Example: 120.hMin(150) - will return at least 150 logical pixels
  double hMin(double minHeight) {
    final responsiveHeight = h;
    return responsiveHeight > minHeight ? responsiveHeight : minHeight;
  }

  /// Alternative version that uses the existing .h extension
  /// Example: 120.h(minHeight: 150)
  double hWithMin({double minHeight = 0}) {
    final responsiveHeight = h;
    return responsiveHeight > minHeight ? responsiveHeight : minHeight;
  }
}

/// Adds responsive sizing extensions to EdgeInsets
extension ResponsiveEdgeInsetsExtension on EdgeInsets {
  /// Scale all edge insets by width factor
  EdgeInsets get w => copyWith(
    left: left * ResponsiveManager.globalInstance.scaleWidth(1),
    top: top * ResponsiveManager.globalInstance.scaleWidth(1),
    right: right * ResponsiveManager.globalInstance.scaleWidth(1),
    bottom: bottom * ResponsiveManager.globalInstance.scaleWidth(1),
  );

  /// Scale all edge insets by height factor
  EdgeInsets get h => copyWith(
    left: left * ResponsiveManager.globalInstance.scaleHeight(1),
    top: top * ResponsiveManager.globalInstance.scaleHeight(1),
    right: right * ResponsiveManager.globalInstance.scaleHeight(1),
    bottom: bottom * ResponsiveManager.globalInstance.scaleHeight(1),
  );

  /// Scale all edge insets by adaptive factor
  EdgeInsets get r => copyWith(
    left: left * ResponsiveManager.globalInstance.adaptiveScale(1),
    top: top * ResponsiveManager.globalInstance.adaptiveScale(1),
    right: right * ResponsiveManager.globalInstance.adaptiveScale(1),
    bottom: bottom * ResponsiveManager.globalInstance.adaptiveScale(1),
  );
}

/// Extension to add responsive utilities to BuildContext
extension ResponsiveContextExtension on BuildContext {
  /// Initialize global responsive instance from this context
  /// Returns true if initialized for the first time
  bool initGlobalResponsive() {
    return ResponsiveManager.initGlobal(this);
  }

  /// Get the layout adapter for this context
  LayoutAdapter get responsive => LayoutAdapter.of(this);

  /// Get screen size from MediaQuery
  Size get screenSize => MediaQuery.of(this).size;

  /// Check if device is in landscape orientation
  bool get isLandscape => screenSize.width > screenSize.height;

  /// Check if device is in portrait orientation
  bool get isPortrait => !isLandscape;

  /// Get responsive width dimension
  double rw(double width) => responsive.scaleWidth(width);

  /// Get responsive height dimension
  double rh(double height) => responsive.scaleHeight(height);

  /// Get responsive font size
  double rf(double size) => responsive.scaleFont(size);

  /// Get adaptive dimension (based on both width and height)
  double ra(double size) => responsive.adaptiveScale(size);

  /// Get responsive symmetric padding
  EdgeInsets rPadding(double horizontal, double vertical) => EdgeInsets.symmetric(horizontal: rw(horizontal), vertical: rh(vertical));

  /// Get responsive all-side padding
  EdgeInsets rPaddingAll(double value) => EdgeInsets.all(ra(value));

  /// Get screen width percentage (1.sw = 100% of screen width)
  double sw(double percentage) => responsive.screenSize.width * (percentage);

  /// Get screen height percentage (1.sh = 100% of screen height)
  double sh(double percentage) => responsive.screenSize.height * (percentage);

  /// Detect current device type based on width
  DeviceType get deviceType {
    final width = screenSize.width;
    if (width < 600) return DeviceType.phone;
    if (width < 1024) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Check if running on phone-sized device
  bool get isPhone => deviceType == DeviceType.phone;

  /// Check if running on tablet-sized device
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if running on desktop-sized device
  bool get isDesktop => deviceType == DeviceType.desktop;
}

/// Adds responsive sizing extensions to Widget
extension ResponsiveWidgetExtension on Widget {
  /// Add responsive padding on all sides
  Widget paddingAll(double value) => Padding(padding: EdgeInsets.all(value.r), child: this);

  /// Add responsive horizontal padding
  Widget paddingHorizontal(double value) => Padding(padding: EdgeInsets.symmetric(horizontal: value.w), child: this);

  /// Add responsive vertical padding
  Widget paddingVertical(double value) => Padding(padding: EdgeInsets.symmetric(vertical: value.h), child: this);

  /// Add responsive symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(padding: EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h), child: this);

  /// Add responsive directional padding
  Widget paddingOnly({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      Padding(padding: EdgeInsets.only(left: left.w, top: top.h, right: right.w, bottom: bottom.h), child: this);

  /// Wrap with sized box of responsive width
  Widget width(double width) => SizedBox(width: width.w, child: this);

  /// Wrap with sized box of responsive height
  Widget height(double height) => SizedBox(height: height.h, child: this);

  /// Wrap with sized box of responsive width and height
  Widget size(double width, double height) => SizedBox(width: width.w, height: height.h, child: this);

  /// Apply responsive margin on all sides
  Widget marginAll(double value) => Container(margin: EdgeInsets.all(value.r), child: this);

  /// Apply responsive horizontal margin
  Widget marginHorizontal(double value) => Container(margin: EdgeInsets.symmetric(horizontal: value.w), child: this);

  /// Apply responsive vertical margin
  Widget marginVertical(double value) => Container(margin: EdgeInsets.symmetric(vertical: value.h), child: this);

  /// Apply responsive symmetric margin
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) => Container(margin: EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h), child: this);

  /// Apply responsive directional margin
  Widget marginOnly({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      Container(margin: EdgeInsets.only(left: left.w, top: top.h, right: right.w, bottom: bottom.h), child: this);

  /// Make widget conditionally responsive based on device type
  Widget responsiveBuilder({Widget Function(Widget child)? phone, Widget Function(Widget child)? tablet, Widget Function(Widget child)? desktop}) {
    final deviceType = ResponsiveConfig.deviceType;

    if (deviceType == DeviceType.phone && phone != null) {
      return phone(this);
    } else if (deviceType == DeviceType.tablet && tablet != null) {
      return tablet(this);
    } else if (deviceType == DeviceType.desktop && desktop != null) {
      return desktop(this);
    }

    return this;
  }

  /// Listen to dimension changes and rebuild when they occur
  Widget dimensionListener({Key? key}) => _DimensionListenerWidget(key: key, child: this);
}

/// Widget that listens to dimension changes and rebuilds child
class _DimensionListenerWidget extends StatefulWidget {
  final Widget child;

  const _DimensionListenerWidget({super.key, required this.child});

  @override
  State<_DimensionListenerWidget> createState() => _DimensionListenerWidgetState();
}

class _DimensionListenerWidgetState extends State<_DimensionListenerWidget> {
  @override
  void initState() {
    super.initState();
    DimensionChangeNotifier.instance.addListener(_handleDimensionChange);
  }

  @override
  void dispose() {
    DimensionChangeNotifier.instance.removeListener(_handleDimensionChange);
    super.dispose();
  }

  void _handleDimensionChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
