import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
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

  LinearGradient deckGradient() {
    return AppColors.blueToDarkGradient;
  }
}
