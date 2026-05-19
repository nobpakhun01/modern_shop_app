import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/language_provider.dart';
import 'providers/product_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ModernShopApp());
}

class ModernShopApp extends StatelessWidget {
  const ModernShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFFFFBF2);
    const gold = Color(0xFFD4AF37);
    const darkGold = Color(0xFF8A6A16);
    const textDark = Color(0xFF1F1A12);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Modern Shop',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: cream,
          colorScheme: ColorScheme.fromSeed(
            seedColor: gold,
            brightness: Brightness.light,
          ).copyWith(primary: gold, secondary: darkGold, surface: Colors.white),
          textTheme: GoogleFonts.montserratTextTheme().apply(
            bodyColor: textDark,
            displayColor: textDark,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: cream,
            elevation: 0,
            centerTitle: false,
            iconTheme: const IconThemeData(color: darkGold),
            titleTextStyle: GoogleFonts.playfairDisplay(
              color: textDark,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0x44D4AF37), width: 1),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(color: Color(0xFF8A6A16)),
            hintStyle: const TextStyle(color: Color(0xFF9B9487)),
            prefixIconColor: darkGold,
            suffixIconColor: darkGold,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0x55D4AF37)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: gold, width: 1.4),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: gold,
            foregroundColor: Colors.black,
          ),
          dividerTheme: const DividerThemeData(color: Color(0x33D4AF37)),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoggedIn) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}
