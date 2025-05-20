# FlutterResponsive

[//]: # ([![Pub Version]&#40;https://img.shields.io/pub/v/responsive_manager.svg&#41;]&#40;https://pub.dev/packages/responsive_manager&#41;)
[![Build Status](https://github.com/kenresoft/responsive_manager/workflows/build/badge.svg)](https://github.com/kenresoft/responsive_manager/actions)
[![Coverage Status](https://coveralls.io/repos/github/kenresoft/responsive_manager/badge.svg?branch=main)](https://coveralls.io/github/kenresoft/responsive_manager?branch=main)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Effortless responsive UI scaling for Flutter across all device types.

## 🚀 Features

- **Universal Scaling**: Proportionally scale UI elements across different device sizes and orientations
- **Smart Caching**: Optimized caching strategy for improved performance
- **Device Type Detection**: Automatic detection of phone, tablet, and desktop formats
- **Intuitive Extensions**: Simple extension methods for responsive dimensions and widgets
- **Configuration Presets**: Ready-to-use presets for common device sizes
- **Layout Adapters**: Context-specific responsive adaptations
- **Performance Optimized**: Minimizes rebuilds and uses efficient LRU caching

## 📱 Installation

```yaml
dependencies:
  responsive_manager: ^1.0.0
```

## 🛠️ Quick Start

1. Initialize the responsive system at the root of your app:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInitializer(
      child: MaterialApp(
        title: 'Responsive App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
```

2. Use responsive extensions in your widgets:

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Demo', style: TextStyle(fontSize: 18.sp)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.w,
              height: 100.h,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Responsive Box',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ).paddingAll(20.r),
            
            Text(
              'Screen size: ${context.screenSize.width.toStringAsFixed(1)} x ${context.screenSize.height.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 14.sp),
            ),
            
            Text(
              'Device type: ${context.deviceType.name}',
              style: TextStyle(fontSize: 14.sp),
            ).paddingVertical(10.h),
          ],
        ),
      ),
    );
  }
}
```

## 📐 Core Concepts

### Responsive Extensions

| Extension | Description |
|-----------|-------------|
| `value.w` | Width scaling based on design reference |
| `value.h` | Height scaling based on design reference |
| `value.sp` | Font size scaling with system adjustment |
| `value.r` | Adaptive scaling (balanced width/height) |
| `value.sw` | Screen width percentage (0.5.sw = 50% of screen width) |
| `value.sh` | Screen height percentage (0.5.sh = 50% of screen height) |

### Widget Extensions

| Extension | Description |
|-----------|-------------|
| `widget.paddingAll(value)` | Add responsive padding on all sides |
| `widget.paddingHorizontal(value)` | Add responsive horizontal padding |
| `widget.paddingVertical(value)` | Add responsive vertical padding |
| `widget.width(value)` | Set responsive width |
| `widget.height(value)` | Set responsive height |
| `widget.marginAll(value)` | Add responsive margin on all sides |
| `widget.responsiveBuilder()` | Apply device-specific transformations |

### Context Extensions

| Extension | Description |
|-----------|-------------|
| `context.responsive` | Get layout adapter for context |
| `context.screenSize` | Get screen size |
| `context.isLandscape` | Check if device is in landscape |
| `context.isPortrait` | Check if device is in portrait |
| `context.deviceType` | Get current device type |
| `context.isPhone` | Check if running on phone |
| `context.isTablet` | Check if running on tablet |
| `context.isDesktop` | Check if running on desktop |

## 🔧 Configuration

### Design Reference

Set your design reference dimensions to match your design specs:

```dart
void main() {
  // Configure responsive system for iPhone 13 Pro design
  ResponsiveConfig.configure(
    width: 390,
    height: 844,
    minFontScale: 0.8,
    maxFontScale: 1.2,
  );
  
  runApp(const MyApp());
}
```

### Built-in Presets

```dart
// iPhone 13 Pro preset
ResponsiveConfig.useIPhone13Pro();

// Google Pixel preset
ResponsiveConfig.usePixel();

// Tablet preset
ResponsiveConfig.useTablet();

// Desktop preset
ResponsiveConfig.useDesktop();
```

## 🏗️ Advanced Usage

### Responsive Builder

```dart
ResponsiveBuilder(
  builder: (context, layout) {
    return Container(
      width: layout.scaleWidth(200),
      height: layout.scaleHeight(100),
      child: Text('Adaptive UI', style: TextStyle(fontSize: layout.scaleFont(16))),
    );
  },
)
```

### Device Type Condition

```dart
ResponsiveCondition(
  phone: const MobileLayout(),
  tablet: const TabletLayout(),
  desktop: const DesktopLayout(),
  fallback: const DefaultLayout(), // Fallback if none provided
)
```

### Advanced Responsive Builder

```dart
AdvancedResponsiveBuilder(
  builder: (context, deviceType, layout, sizeClass) {
    // Use sizeClass for more granular control
    switch (sizeClass) {
      case SizeClass.xs:
        return const ExtraSmallLayout();
      case SizeClass.sm:
        return const SmallLayout();
      case SizeClass.md:
        return const MediumLayout();
      case SizeClass.lg:
        return const LargeLayout();
      case SizeClass.xl:
      case SizeClass.xxl:
        return const ExtraLargeLayout();
    }
  },
)
```

### Listening to Dimension Changes

```dart
// Manually force a responsive rebuild
context.forceResponsiveRebuild();

// Wrap a widget to auto-rebuild on dimension changes
myWidget.dimensionListener()
```

## 🧪 Testing

Special test constructor for unit and widget testing:

```dart
testWidgets('Responsive manager scales correctly', (tester) async {
  final mediaQueryData = MediaQueryData(
    size: const Size(390, 844),
    devicePixelRatio: 2.0,
  );
  
  final responsiveManager = ResponsiveManager.test(
    mediaQueryData,
    widthFactor: 1.0,
    heightFactor: 1.0,
  );
  
  expect(responsiveManager.scaleWidth(100), equals(100.0));
  expect(responsiveManager.scaleHeight(100), equals(100.0));
});
```

## 📊 Performance Optimization

The package includes various performance optimizations:

- LRU cache with limited size to prevent memory issues
- Smart invalidation strategy to minimize rebuilds
- Throttling mechanism to prevent excessive dimension change notifications
- Efficient inherited widgets for propagating dimension changes

## 📘 Examples

Check the `/example` folder for complete implementation examples:

- Basic Responsive App
- Responsive Dashboard
- Adaptive E-commerce UI
- Multi-device Form Layout

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
