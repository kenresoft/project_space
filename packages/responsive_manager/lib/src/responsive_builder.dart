part of 'responsive_manager.dart';

/// A builder function that takes a BuildContext and returns a Widget
typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context, LayoutAdapter layout);

/// A widget that rebuilds when screen dimensions change
class ResponsiveBuilder extends StatefulWidget {
  /// Builder function to create the widget
  final ResponsiveWidgetBuilder builder;

  /// Whether to force a rebuild on every frame
  /// Use with caution - only needed for continuous animations
  final bool continuousRebuild;

  /// Create a responsive builder widget
  const ResponsiveBuilder({super.key, required this.builder, this.continuousRebuild = false});

  @override
  State<ResponsiveBuilder> createState() => _ResponsiveBuilderState();
}

class _ResponsiveBuilderState extends State<ResponsiveBuilder> {
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    if (!widget.continuousRebuild) {
      DimensionChangeNotifier.instance.addListener(_onDimensionChange);
    }
  }

  @override
  void dispose() {
    if (!widget.continuousRebuild) {
      DimensionChangeNotifier.instance.removeListener(_onDimensionChange);
    }
    super.dispose();
  }

  void _onDimensionChange() {
    final currentSize = DimensionChangeNotifier.instance.currentSize;
    if (_lastSize != currentSize) {
      _lastSize = currentSize;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Capture screen size for change detection
    _lastSize = MediaQuery.of(context).size;

    // Get adapter instance for this context
    final adapter = ResponsiveManager.of(context);

    if (widget.continuousRebuild) {
      // For continuous rebuild mode, use AnimatedBuilder with implicit animation
      return AnimatedBuilder(animation: Listenable.merge([DimensionChangeNotifier.instance /*WidgetsBinding.instance*/]), builder: (context, _) => widget.builder(context, adapter));
    }

    // Standard mode - rebuild only when dimensions actually change
    return widget.builder(context, adapter);
  }
}

/// A conditional builder that selects different layouts based on device type
class ResponsiveCondition extends StatelessWidget {
  /// Widget to display on phone devices
  final Widget? phone;

  /// Widget to display on tablet devices
  final Widget? tablet;

  /// Widget to display on desktop devices
  final Widget? desktop;

  /// Fallback widget if no specific widget is provided for current device type
  final Widget? fallback;

  /// Create a responsive condition widget
  const ResponsiveCondition({super.key, this.phone, this.tablet, this.desktop, this.fallback})
    : assert(phone != null || tablet != null || desktop != null || fallback != null, 'At least one widget must be provided');

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;

    switch (deviceType) {
      case DeviceType.phone:
        return phone ?? fallback ?? _getFirstNonNull() ?? const SizedBox.shrink();
      case DeviceType.tablet:
        return tablet ?? fallback ?? _getFirstNonNull() ?? const SizedBox.shrink();
      case DeviceType.desktop:
        return desktop ?? fallback ?? _getFirstNonNull() ?? const SizedBox.shrink();
    }
  }

  /// Helper to get the first non-null widget
  Widget? _getFirstNonNull() {
    if (phone != null) return phone;
    if (tablet != null) return tablet;
    if (desktop != null) return desktop;
    return null;
  }
}

/// Layout breakpoints for standard device sizes
class Breakpoints {
  Breakpoints._();

  /// Maximum width for small mobile devices
  static const double mobileSmall = 320;

  /// Maximum width for medium mobile devices
  static const double mobileMedium = 375;

  /// Maximum width for large mobile devices
  static const double mobileLarge = 414;

  /// Maximum width for small tablet devices
  static const double tabletSmall = 600;

  /// Maximum width for medium tablet devices
  static const double tabletMedium = 768;

  /// Maximum width for large tablet devices
  static const double tabletLarge = 1024;

  /// Maximum width for small desktop devices
  static const double desktopSmall = 1280;

  /// Maximum width for medium desktop devices
  static const double desktopMedium = 1440;

  /// Maximum width for large desktop devices
  static const double desktopLarge = 1920;
}

/// Enhanced builder that provides both size conditions and device type
class AdvancedResponsiveBuilder extends StatelessWidget {
  /// Builder function that receives detailed size information
  final Widget Function(BuildContext context, DeviceType deviceType, LayoutAdapter layout, SizeClass sizeClass) builder;

  /// Create an advanced responsive builder
  const AdvancedResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        final width = layout.screenSize.width;
        final deviceType = context.deviceType;
        final sizeClass = _getSizeClass(width);

        return builder(context, deviceType, layout, sizeClass);
      },
    );
  }

  /// Determine the size class based on width
  SizeClass _getSizeClass(double width) {
    if (width <= Breakpoints.mobileSmall) return SizeClass.xs;
    if (width <= Breakpoints.mobileLarge) return SizeClass.sm;
    if (width <= Breakpoints.tabletMedium) return SizeClass.md;
    if (width <= Breakpoints.tabletLarge) return SizeClass.lg;
    if (width <= Breakpoints.desktopMedium) return SizeClass.xl;
    return SizeClass.xxl;
  }
}

/// Size class enumeration for semantic sizing
enum SizeClass {
  /// Extra small devices
  xs,

  /// Small devices
  sm,

  /// Medium devices
  md,

  /// Large devices
  lg,

  /// Extra large devices
  xl,

  /// Double extra large devices
  xxl,
}
