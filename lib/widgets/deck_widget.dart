import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/screens/deck_screen.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/helpers.dart';

class DeckWidget extends StatelessWidget {
  final Deck? deck; // Deck can be null
  final VoidCallback? onPressed;
  final BuildContext homeScreenContext; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list

  const DeckWidget({
    Key? key,
    required this.deck,
    this.onPressed,
    required this.homeScreenContext,
    required this.deckIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deck!.defaultDeck) {
      return GestureDetector(
        onTap: () {
          Helpers.showAddDeckDialog(context, "Add new deck", deckIndex);
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            gradient: deck!.backgroundColor,
            border: Border.all(color: AppColors.darkGrey, width: 5),
            borderRadius: BorderRadius.circular(10.0),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Icon(
                  deck!.iconData,
                  color: AppColors.lightGrey,
                  size: 48.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                deck!.name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeckScreen(
                deck: deck ??
                    Deck(
                      name: 'Default Deck',
                      iconData: Icons.widgets,
                      buttons: [],
                    ),
              ), // Provide a default value for deck
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            gradient: deck!.backgroundColor,
            border: Border.all(color: AppColors.darkGrey, width: 5),
            borderRadius: BorderRadius.circular(10.0),
            shape: BoxShape
                .rectangle, // Use BoxShape.rectangle to add a rounded border
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Icon(
                  deck!.iconData,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                deck?.name ?? "Add name to deck",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
  }
}
