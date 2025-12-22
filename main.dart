import 'package:flutter/material.dart';
import 'features/listings/presentation/pages/login_page.dart';
import 'app_theme.dart';
import 'theme_controller.dart';
import 'widgets/responsive_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // listen to theme changes
    ThemeController.instance.mode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company Marketplace',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeController.instance.mode.value,

      // 🔹 IMPORTANT:
      // App must ALWAYS start at LoginPage.
      // MainNavigation(isAdmin: ...) is pushed ONLY after login.
      home: const ResponsiveWrapper(child: LoginPage()),
    );
  }
}
