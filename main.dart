import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/listings/presentation/pages/login_page.dart';
import 'app_theme.dart';
import 'theme_controller.dart';
import 'services/listing_provider.dart';
import 'services/wishlist_provider.dart';


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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListingProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Company Marketplace',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeController.instance.mode.value,
        home: const LoginPage(),
      ),
    );
  }
}
