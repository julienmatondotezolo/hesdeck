import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hessdeck/models/deck.dart';

class DeckProvider extends ChangeNotifier {
  final List<Deck> _decks = []; // Initial empty list of decks

  List<Deck> get decks => _decks;

  void addDeck(Deck deck) {
    _decks.add(deck);
    notifyListeners();
  }

  void removeDeck(Deck deck) {
    _decks.remove(deck);
    notifyListeners();
  }

  // Add any additional methods for managing decks here.
}

// Convenience method to access the DeckProvider instance
DeckProvider deckProvider(BuildContext context) {
  return Provider.of<DeckProvider>(context, listen: false);
}
