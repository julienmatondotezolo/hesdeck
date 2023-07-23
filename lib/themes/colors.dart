import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlack = Color(0xFF202020);
  static const Color darkGrey = Color(0xFF313131);
  static const Color lightGrey = Color(0xFF9D9D9D);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2A3245), Color(0xFF080A0E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient blueToGreyGradient = LinearGradient(
    colors: [Color(0xFF1F1E26), Color(0xFF262626)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
