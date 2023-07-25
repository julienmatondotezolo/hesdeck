import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/screens/deck_screen.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:provider/provider.dart';

class Helpers {
  // Function to show a dialog
  static void showAddDeckDialog(
      BuildContext context, String message, int deckIndex) {
    final deckNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: TextField(
            controller: deckNameController,
            decoration: InputDecoration(labelText: message),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (deckNameController.text.isNotEmpty) {
                  final newDeck = Deck(
                    name: deckNameController.text,
                    iconData: Icons.widgets, // Replace with the desired icon
                    buttons: [],
                    backgroundColor: AppColors.blueToDarkGradient,
                  );
                  Provider.of<DeckProvider>(context, listen: false)
                      .addDeck(newDeck, deckIndex);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  static void updateDeck(BuildContext context, int deckIndex, Deck deck) {
    bool deckClickToggle = deck.clicked == true ? false : true;
    final deckProvider = Provider.of<DeckProvider>(context, listen: false);
    final updatedDeck =
        deck.copyWith(clicked: deckClickToggle); // Mark the deck as active
    deckProvider.updateDeck(updatedDeck, deckIndex);
  }

  static void openDeckScreen(BuildContext context, int deckIndex, Deck deck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckScreen(
          deck: deck, // Provide a default value for deck
          deckIndex: deckIndex,
        ),
      ),
    );
  }

  LinearGradient deckGradient() {
    return AppColors.blueToDarkGradient;
  }
}
