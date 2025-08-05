import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final glassmorphismCardDecoration = BoxDecoration(
  color: Colors.white.withValues(alpha: 0.15),
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
  border: Border.all(
    color: Colors.white.withValues(alpha: 0.2),
    width: 1.5,
  ),
);

ThemeData walletFlowLightTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.montserratTextTheme(),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.white.withValues(alpha: 0.15),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white.withValues(alpha: 0.9),
    indicatorColor: Colors.indigo.withValues(alpha: 0.2),
    labelTextStyle: WidgetStateProperty.all(
      GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
);

ThemeData walletFlowDarkTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.white.withValues(alpha: 0.10),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.black.withValues(alpha: 0.9),
    indicatorColor: Colors.indigo.withValues(alpha: 0.3),
    labelTextStyle: WidgetStateProperty.all(
      GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
);
