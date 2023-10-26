import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/widgets/decks/clickable_deck_widget.dart';
import 'package:hessdeck/widgets/decks/dossier_deck_widget.dart';
import 'package:hessdeck/widgets/decks/empty_deck_widget.dart';
import 'package:hessdeck/widgets/decks/popup_deck_widget.dart';

class DeckWidget extends StatelessWidget {
  final Deck? deck; // Deck can be null
  final VoidCallback? onPressed;
  final BuildContext homeScreenContext; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list
  final int? folderIndex;

  const DeckWidget({
    Key? key,
    required this.deck,
    this.onPressed,
    required this.homeScreenContext,
    required this.deckIndex,
    this.folderIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deck!.dossierDeck) {
      return DossierDeckWidget(
        deck: deck,
        context: context,
        deckIndex: deckIndex,
      );
    } else if (deck!.clickableDeck) {
      return ClickableDeckWidget(
        deck: deck,
        context: context,
        deckIndex: deckIndex,
        folderIndex: folderIndex,
      );
    } else if (deck!.defaultDeck) {
      return EmptyDeckWidget(
        deck: deck,
        context: context,
        deckIndex: deckIndex,
        folderIndex: folderIndex,
      );
    } else if (deck!.popupDeck) {
      return PopupDeckWidget(
        deck: deck,
        context: context,
        deckIndex: deckIndex,
        folderIndex: folderIndex,
      );
    }

    // Display CircularProgressIndicator and loading text when deck is null (loading)
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkGrey, width: 5),
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
