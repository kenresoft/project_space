# Changelog

## [1.0.0] - 2025-05-20

Initial release with core responsive features:

- Added `ResponsiveManager` for centralized dimension handling
- Implemented responsive number extensions (`.w`, `.h`, `.sp`, `.r`)
- Added widget extensions for padding, margin, sizing
- Implemented `BuildContext` extensions for responsive dimensions
- Added `ResponsiveInitializer` for app-wide setup
- Implemented `ResponsiveBuilder` for dimension-aware widgets
- Added `ResponsiveCondition` for device-type specific layouts
- Added `AdvancedResponsiveBuilder` with size class detection
- Implemented device type detection (phone, tablet, desktop)
- Added configurable design reference dimensions
- Implemented presets for common device configurations
- Added adaptive font scaling with accessibility support
- Implemented orientation change handling
- Added efficient caching mechanism for better performance
- Implemented device-specific adjustment factors

Known Issues:

- Limited support for foldable devices (planned for next release)
- Orientation listener may cause mild performance impact on lower-end devices