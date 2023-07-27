import 'package:flutter/material.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deckProvider = Provider.of<DeckProvider>(context);

    // Get the screen height using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;

    print('[PROVIDER DECKS SAVED]: ${deckProvider.decks.length}');

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25.0), // Add padding to create spacing
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
                      // Add your settings button functionality here
                    },
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05, // 5% of the screen height
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio:
                        1, // Aspect ratio of each grid item (width/height)
                  ),
                  itemCount: deckProvider.decks.length,
                  itemBuilder: (context, index) {
                    final deck = deckProvider.decks[index];

                    return DeckWidget(
                      deck: deck,
                      homeScreenContext:
                          context, // Pass the HomeScreen's context
                      deckIndex: index, // Pass the index to DeckWidget
                    );
                  },
                ),
              ),
              // Add additional widgets below if needed
            ],
          ),
        ),
      ),
    );
  }
}
