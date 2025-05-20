import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/widgets.dart';

part 'responsive_builder.dart';
part 'responsive_config.dart';
part 'responsive_extensions.dart';
part 'responsive_initializer.dart';

/// A centralized event notifier to propagate dimension changes across the app
class DimensionChangeNotifier extends ChangeNotifier {
  static final DimensionChangeNotifier _instance = DimensionChangeNotifier._();

  /// Get the singleton instance
  static DimensionChangeNotifier get instance => _instance;

  /// Current app dimensions
  Size _currentSize = Size.zero;

  /// Get current app dimensions
  Size get currentSize => _currentSize;

  /// Set current dimensions and notify if changed
  void updateDimensions(Size size) {
    if (_currentSize != size) {
      _currentSize = size;
      notifyListeners();
    }
  }

  /// Private constructor
  DimensionChangeNotifier._();

  /// Notify all listeners of dimension changes
  void notifyDimensionChange() {
    notifyListeners();
  }
}

/// The core interface defining responsive adaptation operations
abstract class LayoutAdapter {
  double scaleWidth(double width);

  double scaleHeight(double height);

  double scaleFont(double size);

  double adaptiveScale(double size);

  double get safeAreaTop;

  double get safeAreaBottom;

  Size get screenSize;

  double get pixelRatio;

  double get textScaleFactor;

  EdgeInsets get padding;

  // Factory constructor to provide the appropriate adapter
  factory LayoutAdapter.of(BuildContext context) => ResponsiveManager.of(context);
}

/// Handles the case when no adapter is available (safer than null)
class FallbackLayoutAdapter implements LayoutAdapter {
  const FallbackLayoutAdapter();

  @override
  double scaleWidth(double width) => width;

  @override
  double scaleHeight(double height) => height;

  @override
  double scaleFont(double size) => size;

  @override
  double adaptiveScale(double size) => size;

  @override
  double get safeAreaTop => 0;

  @override
  double get safeAreaBottom => 0;

  @override
  Size get screenSize => const Size(0, 0);

  @override
  double get pixelRatio => 1.0;

  @override
  double get textScaleFactor => 1.0;

  @override
  EdgeInsets get padding => EdgeInsets.zero;
}

/// ResponsiveManager implements LayoutAdapter with optimized caching strategy
class ResponsiveManager implements LayoutAdapter {
  // Private constructor for singleton pattern per context
  ResponsiveManager._(this._mediaQuery) {
    _initScaleFactors();

    // Update global dimension notifier
    DimensionChangeNotifier.instance.updateDimensions(_mediaQuery.size);
  }

  /// Constructor for unit/integration test purposes
  /// Initializes ResponsiveManager with a specific MediaQueryData.
  /// This is useful for testing responsive behavior in controlled environments.
  ResponsiveManager.test(this._mediaQuery, {double? widthFactor, double? heightFactor}) {
    _initScaleFactors();
    // Allow overriding scale factors for testing purposes
    // This is useful for simulating specific responsive behaviors
    _widthFactor = widthFactor ?? _widthFactor;
    _heightFactor = heightFactor ?? _heightFactor;
  }

  /// Getter for width factor, accessible for testing.
  double get widthFactorForTest => _widthFactor;

  /// Getter for height factor, accessible for testing.
  double get heightFactorForTest => _heightFactor;

  // LRU cache with limited size to prevent memory issues
  static final int _maxCacheSize = 5;
  static final _cache = _LRUCache<int, ResponsiveManager>(_maxCacheSize);

  // Media query reference
  final MediaQueryData _mediaQuery;

  // Cached scale factors
  late final double _widthFactor;
  late final double _heightFactor;
  late final double _adaptiveFactor;

  // Platform-specific adjustments
  late final double _platformFontAdjustment;

  // Global instance for context-free access (with initialization tracking)
  static ResponsiveManager? _globalInstance;
  static bool _globalInitialized = false;

  // Fallback adapter when no valid instance is available
  static const FallbackLayoutAdapter _fallbackAdapter = FallbackLayoutAdapter();

  // Initialize scale factors based on current configuration
  void _initScaleFactors() {
    _widthFactor = _mediaQuery.size.width / ResponsiveConfig.designWidth;
    _heightFactor = _mediaQuery.size.height / ResponsiveConfig.designHeight;

    // Sophisticated adaptive factor that balances width and height based on orientation
    final isLandscape = _mediaQuery.size.width > _mediaQuery.size.height;
    _adaptiveFactor = isLandscape ? (_widthFactor * 0.65) + (_heightFactor * 0.35) : (_widthFactor * 0.6) + (_heightFactor * 0.4);

    // Platform-specific font adjustments
    _platformFontAdjustment =
        defaultTargetPlatform == TargetPlatform.iOS
            ? 0.95
            : defaultTargetPlatform == TargetPlatform.macOS
            ? 0.98
            : 1.0;
  }

  /// Factory constructor with optimized caching
  factory ResponsiveManager.of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final key = mediaQuery.hashCode;

    // Check if we have a valid cached instance
    final cachedInstance = _cache.get(key);

    if (cachedInstance != null) {
      return cachedInstance;
    }

    // Create a new instance and cache it
    final instance = ResponsiveManager._(mediaQuery);
    _cache.put(key, instance);

    // Update global instance if not yet initialized
    if (!_globalInitialized) {
      _globalInstance = instance;
      _globalInitialized = true;
    }

    return instance;
  }

  /// Get the global instance, with fallback to a safe default adapter
  static LayoutAdapter get globalInstance {
    if (_globalInitialized && _globalInstance != null) {
      return _globalInstance!;
    }
    return _fallbackAdapter;
  }

  /// Check if a global instance has been initialized
  static bool get hasGlobalInstance => _globalInitialized && _globalInstance != null;

  /// Initialize global instance with a specific context
  /// Returns true if successful initialization occurred
  static bool initGlobal(BuildContext context) {
    // Already initialized, no action needed
    if (_globalInitialized && _globalInstance != null) return false;

    // Force initialization of global instance
    _globalInstance = ResponsiveManager.of(context);
    _globalInitialized = true;
    return true;
  }

  /// Reset the global instance
  static void resetGlobal() {
    _globalInstance = null;
    _globalInitialized = false;
  }

  /// Invalidate the cache (useful when orientation changes or config updates)
  static void invalidateCache() {
    _cache.clear();
    resetGlobal();
    // Notify dimension change observers
    DimensionChangeNotifier.instance.notifyDimensionChange();
  }

  @override
  double scaleWidth(double width) => width * _widthFactor;

  @override
  double scaleHeight(double height) => height * _heightFactor;

  @override
  double scaleFont(double size) {
    // Advanced font scaling with smart adjustments
    final scaleFactor = _adaptiveFactor;

    // Apply platform-specific adjustments
    final platformAdjustedFactor = scaleFactor * _platformFontAdjustment;

    // Apply text scale factor from system settings with smart clamping
    final rawSystemScaleFactor = _mediaQuery.textScaler.scale(1.0);

    // Progressive clamping: allow more scaling for smaller fonts, less for larger
    final adaptiveSystemFactor =
        size <= 14
            ? rawSystemScaleFactor
            : size >= 24
            ? math.min(rawSystemScaleFactor, 1.1)
            : rawSystemScaleFactor * (1 - ((size - 14) / 10) * 0.1);

    final effectiveScaleFactor = platformAdjustedFactor * adaptiveSystemFactor;

    // Use configurable bounds
    final boundsAdjustedFactor = effectiveScaleFactor.clamp(ResponsiveConfig.minFontScaleFactor, ResponsiveConfig.maxFontScaleFactor);

    return size * boundsAdjustedFactor;
  }

  @override
  double adaptiveScale(double size) => size * _adaptiveFactor;

  // Efficiently expose MediaQuery properties
  @override
  double get safeAreaTop => _mediaQuery.padding.top;

  @override
  double get safeAreaBottom => _mediaQuery.padding.bottom;

  @override
  Size get screenSize => _mediaQuery.size;

  @override
  double get pixelRatio => _mediaQuery.devicePixelRatio;

  @override
  double get textScaleFactor => _mediaQuery.textScaler.scale(1.0);

  @override
  EdgeInsets get padding => _mediaQuery.padding;
}

/// Efficient LRU Cache implementation for ResponsiveManager
class _LRUCache<K, V> {
  _LRUCache(this.maxSize) : assert(maxSize > 0);

  final int maxSize;
  final _entries = <K, V>{};
  final _accessOrder = <K>[];

  V? get(K key) {
    final value = _entries[key];
    if (value != null) {
      // Move to most recently used
      _accessOrder.remove(key);
      _accessOrder.add(key);
    }
    return value;
  }

  void put(K key, V value) {
    if (_entries.containsKey(key)) {
      _accessOrder.remove(key);
    } else if (_entries.length >= maxSize) {
      // Evict least recently used
      final lruKey = _accessOrder.removeAt(0);
      _entries.remove(lruKey);
    }

    _entries[key] = value;
    _accessOrder.add(key);
  }

  void clear() {
    _entries.clear();
    _accessOrder.clear();
  }
}
