import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hessdeck/themes/colors.dart'; // Replace 'your_app_name' with the actual name of your app

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlack,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryBlack,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.primaryBlack,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      // Add more text styles as needed.
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.lightGrey),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryBlack,
    scaffoldBackgroundColor: AppColors.primaryBlack,
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryBlack,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.lightGrey,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      // Add more text styles as needed.
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.lightGrey),
  );
}
