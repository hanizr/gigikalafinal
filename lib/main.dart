import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => StoreProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StoreProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiStore',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kPrimaryColor,
        brightness: p.dark ? Brightness.dark : Brightness.light,
      ),
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/cart': (_) => const CartScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/search': (_) => const SearchScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/category') {
          final cat = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => CategoryScreen(category: cat));
        }
        if (settings.name == '/detail') {
          final id = settings.arguments as int;
          return MaterialPageRoute(builder: (_) => ProductDetailScreen(id: id));
        }
        return null;
      },
    );
  }
}