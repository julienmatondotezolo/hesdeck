import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:provider/provider.dart';

class ProcessDecks {
  static Future<void> dragDecks(
      BuildContext context, List<Deck> newDeckList) async {
    final deckProvider = Provider.of<DeckProvider>(context, listen: false);

    deckProvider.updateDecks(newDeckList);
  }
}
