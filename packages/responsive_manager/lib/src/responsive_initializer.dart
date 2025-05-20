part of 'responsive_manager.dart';

/// Widget that initializes the responsive system at the app root and ensures
/// responsive rebuilds when device dimensions change
class ResponsiveInitializer extends StatefulWidget {
  /// The child widget to render after initialization
  final Widget child;

  /// Whether to handle orientation changes automatically
  final bool enableOrientationHandling;

  /// Optional callback when responsive system is initialized
  final VoidCallback? onInitialized;

  /// Controls how aggressive cache invalidation should be
  final CacheInvalidationStrategy invalidationStrategy;

  /// Optional threshold percentage for size change detection (0.0 to 1.0)
  final double sizeChangeThreshold;

  /// Creates a responsive initializer widget
  ///
  /// [child] is the widget to render after initialization
  /// [enableOrientationHandling] controls whether orientation changes are handled
  /// [onInitialized] callback is triggered after successful initialization
  /// [invalidationStrategy] controls cache invalidation behavior (defaults to smart)
  /// [sizeChangeThreshold] percentage threshold for size change detection (default: 0.05 or 5%)
  const ResponsiveInitializer({
    super.key,
    required this.child,
    this.enableOrientationHandling = true,
    this.onInitialized,
    this.invalidationStrategy = CacheInvalidationStrategy.smart,
    this.sizeChangeThreshold = 0.05,
  });

  @override
  State<ResponsiveInitializer> createState() => _ResponsiveInitializerState();
}

/// Cache invalidation strategy for responsive manager
enum CacheInvalidationStrategy {
  /// Always invalidate on metrics change
  aggressive,

  /// Only invalidate on significant changes (orientation, size threshold)
  smart,

  /// Only invalidate manually or on major changes
  conservative,
}

class _ResponsiveInitializerState extends State<ResponsiveInitializer> with WidgetsBindingObserver {
  Orientation? _lastOrientation;
  Size? _lastSize;

  // Throttle mechanism to prevent excessive rebuilds
  DateTime _lastRebuildTime = DateTime.now();
  static const _minRebuildInterval = Duration(milliseconds: 16); // ~60fps

  // Event subscription for dimension changes
  late final StreamSubscription<void> _dimensionChangeSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Setup dimension change listener using Listenable.addListener
    // which is more efficient than creating a separate AnimatedBuilder
    _dimensionChangeSubscription = Stream.periodic(Duration.zero).listen((_) {
      // This will never actually be called, just used for disposal
    });

    // Register to the dimension notifier
    DimensionChangeNotifier.instance.addListener(_handleDimensionChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    DimensionChangeNotifier.instance.removeListener(_handleDimensionChange);
    _dimensionChangeSubscription.cancel();
    super.dispose();
  }

  /// Handle dimension changes with throttling
  void _handleDimensionChange() {
    // Throttle rebuilds for better performance
    final now = DateTime.now();
    if (now.difference(_lastRebuildTime) < _minRebuildInterval) {
      Future.delayed(_minRebuildInterval, () {
        if (mounted) setState(() {});
      });
      return;
    }

    _lastRebuildTime = now;
    if (mounted) setState(() {});
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!widget.enableOrientationHandling) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processMetricsChange();
    });
  }

  /// Process metrics changes with smart invalidation
  void _processMetricsChange() {
    if (!mounted) return;

    final size = MediaQuery.sizeOf(context);
    final orientation = size.width > size.height ? Orientation.landscape : Orientation.portrait;

    bool shouldInvalidate = false;

    switch (widget.invalidationStrategy) {
      case CacheInvalidationStrategy.aggressive:
        shouldInvalidate = true;
        break;

      case CacheInvalidationStrategy.smart:
        if (_lastOrientation != null && _lastOrientation != orientation) {
          shouldInvalidate = true;
        } else if (_lastSize != null) {
          final widthChange = (_lastSize!.width - size.width).abs() / _lastSize!.width;
          final heightChange = (_lastSize!.height - size.height).abs() / _lastSize!.height;
          if (widthChange > widget.sizeChangeThreshold || heightChange > widget.sizeChangeThreshold) {
            shouldInvalidate = true;
          }
        }
        break;

      case CacheInvalidationStrategy.conservative:
        if (_lastOrientation != null && _lastOrientation != orientation) {
          shouldInvalidate = true;
        }
        break;
    }

    _lastOrientation = orientation;
    _lastSize = size;

    // Update the dimension notifier regardless of cache invalidation
    DimensionChangeNotifier.instance.updateDimensions(size);

    if (shouldInvalidate) {
      ResponsiveManager.invalidateCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.initGlobalResponsive()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final mediaQuery = MediaQuery.of(context);
        _lastSize = mediaQuery.size;
        _lastOrientation = mediaQuery.orientation;

        // Update the dimension notifier with initial size
        DimensionChangeNotifier.instance.updateDimensions(_lastSize!);

        widget.onInitialized?.call();
      });
    }

    // Create a self-rebuilding widget tree that inherits from DimensionChangeNotifier
    return _ResponsiveInheritedRebuild(
      // We use key to force rebuilds when changed state triggers
      key: ValueKey(_lastRebuildTime.millisecondsSinceEpoch),
      child: widget.child,
    );
  }
}

/// Specialized inherited widget that efficiently propagates dimension changes
class _ResponsiveInheritedRebuild extends InheritedWidget {
  const _ResponsiveInheritedRebuild({required super.key, required super.child});

  @override
  bool updateShouldNotify(_ResponsiveInheritedRebuild oldWidget) => true;
}

/// Extension to make the inherited rebuild widget visible to descendants
extension ResponsiveRebuildContext on BuildContext {
  bool get hasResponsiveRebuild => getElementForInheritedWidgetOfExactType<_ResponsiveInheritedRebuild>() != null;

  void forceResponsiveRebuild() {
    DimensionChangeNotifier.instance.notifyDimensionChange();
  }
}
