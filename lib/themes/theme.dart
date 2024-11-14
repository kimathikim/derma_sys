import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.green.shade600, // Calming green for wellness
    scaffoldBackgroundColor:
        Colors.grey.shade100, // Light background for cleanliness
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade700, // Bold for headers
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade800, // Soft text color for readability
      ),
      labelLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white, // White text for buttons
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white, // Clean, white input fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(
        color: Colors.green.shade600, // Soft green for input labels
      ),
      prefixIconColor: Colors.green.shade600, // Green icons for input fields
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600, // Main button color
        foregroundColor: Colors.white, // Text color for buttons
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    iconTheme: IconThemeData(
      color: Colors.purple.shade300, // Pastel icons
      size: 24,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green.shade600, // AppBar color
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white), // Icons in AppBar
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // AppBar text color
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade600, // FAB color
      foregroundColor: Colors.white, // FAB icon color
    ),

    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green, // Primary color
    ).copyWith(
      secondary: Colors.purple.shade300, // Secondary/Accent color
    ),
  );
}
