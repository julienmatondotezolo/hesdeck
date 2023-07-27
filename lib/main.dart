import 'package:flutter/material.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/screens/home_screen.dart';
import 'package:hessdeck/themes/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeckProvider(),
      child: MaterialApp(
        title: 'HessDeck', // Replace with your app's title
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        theme: AppTheme.lightTheme, // Set light theme
        darkTheme: AppTheme.darkTheme, // Set dark theme
        home: const HomeScreen(), // Replace with the initial screen of your app
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
