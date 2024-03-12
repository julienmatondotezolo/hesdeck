import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/screens/home_screen.dart';
import 'package:hessdeck/screens/spotify_screen.dart';
import 'package:hessdeck/themes/app_theme.dart';
import 'package:hessdeck/utils/constants.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeckProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
      ],
      child: MaterialApp(
        title: Constants.appName, // Replace with your app's title
        theme: AppTheme.lightTheme, // Set light theme
        darkTheme: AppTheme.darkTheme, // Set dark theme
        home: const HomeScreen(),
        // home: const MusicKitScreen(),
        // home: const SpotifyScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
