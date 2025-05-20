part of 'responsive_manager.dart';

/// Configuration for responsive sizing reference dimensions
class ResponsiveConfig {
  ResponsiveConfig._();

  // Default design reference dimensions
  static double _designWidth = 390.0;
  static double _designHeight = 844.0;

  // Configurable font scale limits with smart defaults
  static double _minFontScaleFactor = 0.8;
  static double _maxFontScaleFactor = 1.2;

  // Optional device type-specific adjustments
  static final Map<DeviceType, double> _deviceTypeAdjustments = {DeviceType.phone: 1.0, DeviceType.tablet: 0.85, DeviceType.desktop: 0.75};

  // Current device type (auto-detected or manually set)
  static DeviceType _currentDeviceType = DeviceType.phone;

  // Change listeners for dynamic reconfiguration
  static final List<VoidCallback> _listeners = [];

  /// Get current design width reference
  static double get designWidth => _designWidth;

  /// Get current design height reference
  static double get designHeight => _designHeight;

  /// Get minimum font scale factor
  static double get minFontScaleFactor => _minFontScaleFactor;

  /// Get maximum font scale factor
  static double get maxFontScaleFactor => _maxFontScaleFactor;

  /// Get current device type
  static DeviceType get deviceType => _currentDeviceType;

  /// Get device type adjustment factor
  static double get deviceTypeAdjustment => _deviceTypeAdjustments[_currentDeviceType] ?? 1.0;

  /// Configure design dimensions and notify listeners
  ///
  /// This is the primary method to configure the responsive system
  static void configure({required double width, required double height, double? minFontScale, double? maxFontScale, DeviceType? deviceType, Map<DeviceType, double>? deviceAdjustments}) {
    bool changed = false;

    if (_designWidth != width || _designHeight != height) {
      _designWidth = width;
      _designHeight = height;
      changed = true;
    }

    if (minFontScale != null && _minFontScaleFactor != minFontScale) {
      _minFontScaleFactor = minFontScale;
      changed = true;
    }

    if (maxFontScale != null && _maxFontScaleFactor != maxFontScale) {
      _maxFontScaleFactor = maxFontScale;
      changed = true;
    }

    if (deviceType != null && _currentDeviceType != deviceType) {
      _currentDeviceType = deviceType;
      changed = true;
    }

    if (deviceAdjustments != null) {
      _deviceTypeAdjustments.addAll(deviceAdjustments);
      changed = true;
    }

    if (!changed) return;

    // Invalidate existing adapter cache when configuration changes
    ResponsiveManager.invalidateCache();

    // Notify listeners of configuration change
    _notifyListeners();
  }

  /// Detect device type from screen size and apply appropriate configuration
  static void autoDetectDevice(Size screenSize) {
    DeviceType detectedType;

    // Simple device type detection based on screen width
    // These thresholds can be adjusted based on requirements
    final width = screenSize.width;
    if (width < 600) {
      detectedType = DeviceType.phone;
    } else if (width < 1024) {
      detectedType = DeviceType.tablet;
    } else {
      detectedType = DeviceType.desktop;
    }

    if (_currentDeviceType != detectedType) {
      _currentDeviceType = detectedType;
      // Only invalidate cache, don't notify listeners to prevent recursion
      ResponsiveManager.invalidateCache();
    }
  }

  /// Add listener for configuration changes
  static void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Remove listener
  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Notify all listeners of changes
  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }

    // Also notify dimension change listeners to propagate changes
    DimensionChangeNotifier.instance.notifyDimensionChange();
  }

  /// Preset for iPhone 13 Pro dimensions
  static void useIPhone13Pro() {
    configure(width: 390, height: 844, deviceType: DeviceType.phone);
  }

  /// Preset for Google Pixel dimensions
  static void usePixel() {
    configure(width: 411, height: 823, deviceType: DeviceType.phone);
  }

  /// Preset for tablet dimensions
  static void useTablet() {
    configure(width: 768, height: 1024, deviceType: DeviceType.tablet);
  }

  /// Preset for desktop dimensions
  static void useDesktop() {
    configure(width: 1440, height: 900, deviceType: DeviceType.desktop);
  }
}

/// Device type classification
enum DeviceType {
  /// Smartphone devices
  phone,

  /// Tablet devices
  tablet,

  /// Desktop or large display devices
  desktop,
}
