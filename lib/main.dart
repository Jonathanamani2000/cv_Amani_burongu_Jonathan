import 'package:flutter/material.dart';

import 'pages/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final blancTransparent = Colors.white.withValues(alpha: 0.07);

    return MaterialApp(
      title: 'CV Jonathan Burongu',
      debugShowCheckedModeBanner: false,
      // Thème sombre minimaliste : textes blancs sur fond noir/gris.
      theme: ThemeData(
        useMaterial3: true,
        // Noir, blanc et gris, avec UNE seule couleur d'accent (bleu doux).
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8AB4F8), // couleur d'accent : bleu doux
          onPrimary: Color(0xFF0C0D10),
          surface: Color(0xFF111215),
          onSurface: Colors.white,
        ),
        // Les pages laissent voir le fond dégradé (FondGlass).
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: blancTransparent,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: blancTransparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF8AB4F8),
          unselectedItemColor: Colors.white38,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
