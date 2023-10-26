import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:provider/provider.dart';

class ProcessDecks {
  static Future<void> dragDecks(
    BuildContext context,
    List<Deck> deckList,
    int? folderIndex,
  ) async {
    List<Deck> newDeckList = deckList;

    if (folderIndex != null) {
      Deck currentDeck = Provider.of<DeckProvider>(context, listen: false)
          .getDeckbyIndex(folderIndex);

      Deck newDraggedDeck = currentDeck.copyWith(
        content: deckList,
      );

      List<Deck> currentDeckList =
          Provider.of<DeckProvider>(context, listen: false).decks;

      List<Deck>? newCurrentDeckList = List.from(currentDeckList);
      newCurrentDeckList[folderIndex] = newDraggedDeck;

      newDeckList = newCurrentDeckList;
    }

    final deckProvider = Provider.of<DeckProvider>(context, listen: false);
    deckProvider.updateDecks(newDeckList);
  }

  static void addNewDeck(
    BuildContext context,
    int deckIndex,
    int? folderIndex,
    Deck deck,
  ) {
    Deck newDeck = deck;

    if (folderIndex != null) {
      Deck currentDeck = deckProvider(context).getDeckbyIndex(folderIndex);

      List<Deck>? newContent = List.from(currentDeck.content as Iterable);
      newContent[deckIndex] = deck;

      newDeck = currentDeck.copyWith(
        content: newContent,
      );
    }

    deckProvider(context).addDeck(newDeck, folderIndex ?? deckIndex);
    Navigator.pop(context);
  }

  static void removeDeck(
    BuildContext context,
    int deckIndex,
    int? folderIndex,
  ) {
    if (folderIndex != null) {
      print('folderIndex: $folderIndex');
      // print('deckIndex: $deckIndex');
      Deck currentDeck = deckProvider(context).getDeckbyIndex(folderIndex);
      List<Deck>? newContent = List.from(currentDeck.content as Iterable);

      newContent.removeAt(deckIndex);

      Deck defaultDeck = Deck(
        name: 'Add',
        iconData: Icons.add, // Replace this with your desired default icon
        defaultDeck: true,
        backgroundColor: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff2a3245), Color(0xff000000)],
          tileMode: TileMode.clamp,
        ),
      );

      newContent.insert(deckIndex, defaultDeck);

      Deck newDeck = currentDeck.copyWith(
        content: newContent,
      );

      deckProvider(context).updateDeck(newDeck, folderIndex);
    } else {
      deckProvider(context).removeDeck(deckIndex);
    }
  }
}
