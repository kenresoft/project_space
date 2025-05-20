/// Documentation for the responsive framework package
class ResponsiveFrameworkDocs {
  /// Example usage of the responsive framework
  static String get exampleUsage => '''
// Initialize the responsive framework in your app
void main() {
  // Set design reference dimensions (based on design mockups)
  ResponsiveConfig.configure(width: 390, height: 844);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Wrap your app with ResponsiveInitializer
      home: ResponsiveInitializer(
        // Use smart cache invalidation for optimal performance
        invalidationStrategy: CacheInvalidationStrategy.smart,
        child: const HomePage(),
      ),
    );
  }
}

// Example of responsive UI implementation
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Responsive font size with extension method
      appBar: AppBar(title: Text('Responsive App', style: TextStyle(fontSize: 20.sp()))),
      body: Container(
        // Responsive padding based on screen size
        padding: EdgeInsets.all(16.r()),
        child: Column(
          children: [
            // Responsive width sizing
            Container(
              width: 200.w(),
              height: 50.h(),
              color: Colors.blue,
              alignment: Alignment.center,
              // Responsive text using extension method
              child: Text('Responsive Container', style: TextStyle(fontSize: 14.sp())),
            ),
            SizedBox(height: 16.h()),
            // Device-specific UI with ResponsiveBuilder
            ResponsiveBuilder(
              phoneBuilder: (context) => const PhoneLayout(),
              tabletBuilder: (context) => const TabletLayout(),
              // Default builder as fallback
              builder: (context, deviceType) => const DefaultLayout(),
            ),
          ],
        ),
      ),
    );
  }
}
''';

  /// Best practices for using the responsive framework
  static List<String> get bestPractices => [
    'Initialize the framework as early as possible in your app lifecycle',
    'Use .w() for widths, .h() for heights, .sp() for text, and .r() for universal scaling',
    'Separate device-specific layouts using ResponsiveBuilder',
    'Configure design dimensions based on your actual design mockups',
    'Create extension methods for your own design system components',
    'Handle orientation changes appropriately with OrientationBuilder',
    'Use smart cache invalidation strategy for optimal performance',
    'Combine with Flutter\'s layout widgets (Row, Column, Expanded) for best results',
    'Consider text scaling limits for accessibility compliance',
    'Test on various device sizes and orientations',
  ];
}
