import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlack = Color(0xFF202020);
  static const Color darkGrey = Color(0xFF313131);
  static const Color lightGrey = Color(0xFF9D9D9D);
  static const Color blueGrey = Color(0xFF303239);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient activeBlueToDarkGradient = LinearGradient(
    colors: [Color(0xFF1D3D8C), Color.fromARGB(255, 0, 0, 0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueToDarkGradient = LinearGradient(
    colors: [Color(0xFF2A3245), Color(0xFF080A0E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient blueToGreyGradient = LinearGradient(
    colors: [Color(0xFF1F1E26), Color(0xFF262626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}
