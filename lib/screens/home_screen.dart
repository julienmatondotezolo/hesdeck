import 'package:flutter/material.dart';
import 'package:hessdeck/screens/settings/settings_screen.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/widgets/deck_grid_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen height using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor:
                      AppColors.darkGrey, // Set the grey color here
                  radius: 20, // Set the desired radius for the circle
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05, // 5% of the screen height
              ),
              const Expanded(
                child: DeckGridWidget(),
              ),
              // Add additional widgets below if needed
            ],
          ),
        ),
      ),
    );
  }
}
