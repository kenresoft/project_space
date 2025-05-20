import 'package:flutter/material.dart';
import 'package:responsive_manager/responsive_manager.dart';

/// Mock adapter for testing purposes
class MockLayoutAdapter implements LayoutAdapter {
  MockLayoutAdapter({
    this.mockWidth = 390,
    this.mockHeight = 844,
    this.mockPixelRatio = 2.0,
    this.mockTextScaleFactor = 1.0,
    this.mockSafeAreaTop = 47.0,
    this.mockSafeAreaBottom = 34.0,
    this.mockPadding = const EdgeInsets.only(top: 47.0, bottom: 34.0),
  }) {
    _widthFactor = mockWidth / ResponsiveConfig.designWidth;
    _heightFactor = mockHeight / ResponsiveConfig.designHeight;
    _adaptiveFactor = (_widthFactor * 0.6) + (_heightFactor * 0.4);
  }

  /// Mock screen width
  final double mockWidth;

  /// Mock screen height
  final double mockHeight;

  /// Mock pixel ratio
  final double mockPixelRatio;

  /// Mock text scale factor
  final double mockTextScaleFactor;

  /// Mock safe area top padding
  final double mockSafeAreaTop;

  /// Mock safe area bottom padding
  final double mockSafeAreaBottom;

  /// Mock padding
  final EdgeInsets mockPadding;

  late final double _widthFactor;
  late final double _heightFactor;
  late final double _adaptiveFactor;

  @override
  double scaleWidth(double width) => width * _widthFactor;

  @override
  double scaleHeight(double height) => height * _heightFactor;

  @override
  double scaleFont(double size) => size * _adaptiveFactor * mockTextScaleFactor;

  @override
  double adaptiveScale(double size) => size * _adaptiveFactor;

  @override
  double get safeAreaTop => mockSafeAreaTop;

  @override
  double get safeAreaBottom => mockSafeAreaBottom;

  @override
  Size get screenSize => Size(mockWidth, mockHeight);

  @override
  double get pixelRatio => mockPixelRatio;

  @override
  double get textScaleFactor => mockTextScaleFactor;

  @override
  EdgeInsets get padding => mockPadding;
}

/// Widget for testing responsive layouts with specific dimensions
class ResponsiveTestHarness extends StatelessWidget {
  /// The child widget to render
  final Widget child;

  /// Mock screen width
  final double width;

  /// Mock screen height
  final double height;

  /// Mock pixel ratio
  final double pixelRatio;

  /// Mock text scale factor
  final double textScaleFactor;

  /// Mock safe area insets
  final EdgeInsets safeAreaInsets;

  /// Whether to use a mock adapter (true) or real one (false)
  final bool useMockAdapter;

  /// Device orientation
  final Orientation orientation;

  /// Platform brightness
  final Brightness brightness;

  /// Create a responsive test harness
  const ResponsiveTestHarness({
    super.key,
    required this.child,
    this.width = 390,
    this.height = 844,
    this.pixelRatio = 2.0,
    this.textScaleFactor = 1.0,
    this.safeAreaInsets = const EdgeInsets.only(top: 47.0, bottom: 34.0),
    this.useMockAdapter = true,
    this.orientation = Orientation.portrait,
    this.brightness = Brightness.light,
  });

  @override
  Widget build(BuildContext context) {
    // Use a MediaQuery to simulate device properties
    return MediaQuery(
      data: MediaQueryData(
        size: Size(width, height),
        devicePixelRatio: pixelRatio,
        textScaler: TextScaler.linear(textScaleFactor),
        padding: safeAreaInsets,
        viewInsets: EdgeInsets.zero,
        viewPadding: safeAreaInsets,
        // orientation: orientation,
        platformBrightness: brightness,
      ),
      child:
          useMockAdapter
              ? _MockResponsiveProvider(
                adapter: MockLayoutAdapter(
                  mockWidth: width,
                  mockHeight: height,
                  mockPixelRatio: pixelRatio,
                  mockTextScaleFactor: textScaleFactor,
                  mockSafeAreaTop: safeAreaInsets.top,
                  mockSafeAreaBottom: safeAreaInsets.bottom,
                  mockPadding: safeAreaInsets,
                ),
                child: child,
              )
              : ResponsiveInitializer(enableOrientationHandling: true, invalidationStrategy: CacheInvalidationStrategy.aggressive, child: child),
    );
  }
}

/// Provider for mock responsive adapter in tests
class _MockResponsiveProvider extends InheritedWidget {
  final MockLayoutAdapter adapter;

  const _MockResponsiveProvider({required this.adapter, required super.child});

  @override
  bool updateShouldNotify(_MockResponsiveProvider oldWidget) {
    return adapter != oldWidget.adapter;
  }
}

/// Extension methods for testing responsive layouts
/*extension ResponsiveTestingExtensions on WidgetTester {
  /// Simulate a screen size change
  Future<void> changeScreenSize({
    required double width,
    required double height,
    double pixelRatio = 2.0,
    double textScaleFactor = 1.0,
    EdgeInsets safeAreaInsets = const EdgeInsets.only(top: 47.0, bottom: 34.0),
  }) async {
    // Create a binding if it doesn't exist
    final binding = TestWidgetsFlutterBinding.ensureInitialized();

    // Set the screen dimensions
    binding.window.physicalSizeTestValue = Size(width * pixelRatio, height * pixelRatio);
    binding.window.devicePixelRatioTestValue = pixelRatio;
    binding.window.textScaleFactorTestValue = textScaleFactor;
    binding.window.paddingTestValue = safeAreaInsets;
    binding.window.viewPaddingTestValue = safeAreaInsets;

    // Notify that metrics have changed
    binding.handleMetricsChanged();

    // Wait for next frame to ensure changes are applied
    await pump();
    await pump(const Duration(milliseconds: 100));
  }

  /// Simulate a device rotation
  Future<void> rotateDevice() async {
    // Get current device size
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    final currentSize = binding.window.physicalSize / binding.window.devicePixelRatio;

    // Swap dimensions
    await changeScreenSize(
      width: currentSize.height,
      height: currentSize.width,
    );
  }
}*/

/// Test utilities for responsive framework
class ResponsiveTestUtils {
  /// Create test fixtures for responsive framework unit tests
  ///
  /// Provides a test wrapper with MediaQueryData required by the framework
  static Widget testWrapper({
    required Widget child,
    Size screenSize = const Size(390, 844),
    double devicePixelRatio = 2.0,
    double textScaleFactor = 1.0,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets viewInsets = EdgeInsets.zero,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: screenSize, devicePixelRatio: devicePixelRatio, textScaler: TextScaler.linear(textScaleFactor), padding: padding, viewInsets: viewInsets),
      child: child,
    );
  }

  /// Reset responsive framework state between tests
  static void resetFramework() {
    ResponsiveManager.invalidateCache();
    ResponsiveManager.resetGlobal();
  }

  /// Verify calculation correctness with test device dimensions
  static void verifyCalculations({required Size deviceSize, required Size designSize, required double expectedWidthFactor, required double expectedHeightFactor, double epsilon = 0.001}) {
    // Configure design size
    ResponsiveConfig.configure(width: designSize.width, height: designSize.height);

    // Create test instance with specified dimensions
    final mediaQueryData = MediaQueryData(size: deviceSize);
    final adapter = ResponsiveManager.test(mediaQueryData);

    // Verify scaling factors
    final actualWidthFactor = adapter.widthFactorForTest;
    final actualHeightFactor = adapter.heightFactorForTest;

    assert((actualWidthFactor - expectedWidthFactor).abs() < epsilon, 'Width factor: $actualWidthFactor does not match expected: $expectedWidthFactor');

    assert((actualHeightFactor - expectedHeightFactor).abs() < epsilon, 'Height factor: $actualHeightFactor does not match expected: $expectedHeightFactor');
  }
}
