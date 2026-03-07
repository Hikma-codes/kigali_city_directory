import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'providers/listing_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(KigaliApp());
}

class KigaliApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF0D1B2A);
    const Color accentAmber = Color(0xFFFFB81C);

    return ChangeNotifierProvider(
      create: (_) => ListingProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Kigali City Directory",
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: darkBlue,
          scaffoldBackgroundColor: Colors.white,
          // AppBar Theme
          appBarTheme: const AppBarTheme(
            backgroundColor: darkBlue,
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Card Theme
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          // ListTile Theme
          listTileTheme: const ListTileThemeData(
            tileColor: Colors.white,
            textColor: Colors.black,
            subtitleTextStyle: TextStyle(color: Colors.grey),
          ),
          // Text Theme
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.grey),
            labelLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Bottom Navigation Bar Theme
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: darkBlue,
            selectedItemColor: accentAmber,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            elevation: 8,
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
