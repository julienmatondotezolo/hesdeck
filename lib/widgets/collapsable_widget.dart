import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/screens/deck_settings_screen.dart';
import 'package:hessdeck/themes/colors.dart';

class CollapsableWidget extends StatelessWidget {
  final dynamic item;
  final int deckIndex;
  final int? folderIndex;

  const CollapsableWidget({
    super.key,
    required this.item,
    required this.deckIndex,
    this.folderIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white10, width: 2.0),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 26.0),
        backgroundColor: AppColors.primaryBlack,
        collapsedBackgroundColor: AppColors.darkGrey,
        collapsedIconColor: AppColors.white,
        iconColor: Colors.white,
        title: Text(
          item['actionName'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          for (var actionDeck in item['actionDecks'])
            GestureDetector(
              onTap: () {
                openDeckSettingsScreen(
                    context, deckIndex, Deck.fromJson(actionDeck), folderIndex);
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white10, width: 1.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 26.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    actionDeck['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void openDeckSettingsScreen(
  BuildContext context,
  int deckIndex,
  Deck deck,
  int? folderIndex,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DeckSettingsScreen(
        deck: deck, // Provide a default value for deck
        deckIndex: deckIndex,
        folderIndex: folderIndex,
      ),
    ),
  );
}
