import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/screens/navigation/go_router.dart';
import 'package:harris_j_system/screens/shared/on_board_screen.dart';
import 'package:harris_j_system/screens/shared/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // Set background color to white
        primaryColor: Colors.red, // Set primary color to red
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red, // Red theme
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // White AppBar
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.red), // Red icons in AppBar
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Default text color black
          bodyMedium: TextStyle(color: Colors.black),
          labelLarge: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold), // Red for buttons and labels
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red buttons
            foregroundColor: Colors.white, // White text on button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red, // Red text/icons on outlined button
            side: const BorderSide(color: Colors.red), // Red border
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.red), // Default red icons
      ),

      routerConfig: goRouter, // Attach the GoRouter instance
    );
  }
}
