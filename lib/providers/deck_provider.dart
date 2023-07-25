import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeckProvider extends ChangeNotifier {
  final List<Deck> _decks = []; // Initial empty list of decks
  final String _deckListKey =
      'deckList'; // Key to store deck list in SharedPreferences

  List<Deck> get decks => _decks;

  DeckProvider() {
    _loadDecks(); // Load decks from SharedPreferences when the provider is created
  }

  Future<void> _loadDecks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deckListJson = prefs.getString(_deckListKey);

    for (int i = 1; i <= 15; i++) {
      if (deckListJson == null) {
        print('No decks found in SharedPreferences. Adding default decks.');
        // If there is no data in SharedPreferences, add default decks
        for (int i = 1; i <= 15; i++) {
          _addDefaultDeck(i, false);
        }
      } else {
        final List<dynamic> decksJson = jsonDecode(deckListJson);
        _decks.clear();
        _decks.addAll(decksJson.map((json) => Deck.fromJson(jsonDecode(json))));

        // Check if the number of decks is less than 15 and add default decks accordingly
        if (_decks.length < 15) {
          final int remainingDefaultDecks = 15 - _decks.length;
          for (int i = 1; i <= remainingDefaultDecks; i++) {
            _addDefaultDeck(_decks.length + i, false);
          }
          print('Added $remainingDefaultDecks default decks to reach 15.');
        }

        notifyListeners();
      }
    }

    print('[SHARED DECKS SAVED]: ${_decks.length}');
  }

  Future<void> _saveDecks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> decksJson =
        _decks.map((deck) => jsonEncode(deck.toJson())).toList();

    // Store the decksJson as a String using setString method
    prefs.setString(_deckListKey, jsonEncode(decksJson));
    print('Updating SharedPreferences.');
    print('[SHARED DECKS SAVED]: ${decksJson.length}');
  }

  void _addDefaultDeck(int i, bool remove) {
    // Create and add 15 default decks with default name and icon
    final defaultDeck = Deck(
      // name: 'Deck $i',
      name: 'Add',
      iconData: Icons.add, // Replace this with your desired default icon
      buttons: [], // Replace this with any default buttons if needed
      defaultDeck: true,
    );

    if (remove == true) {
      // Insert the default deck at the same index where the removed deck was located
      _decks.insert(i, defaultDeck);
    } else {
      _decks.add(defaultDeck);
    }

    _saveDecks(); // Save the default decks to SharedPreferences
    notifyListeners();
  }

  void addDeck(Deck deck, int index) {
    print('Position of Deck: $index');

    // Remove the default deck at the specified index
    _decks.removeAt(index);

    // Insert the custom deck at the specified index
    _decks.insert(index, deck);

    _saveDecks(); // Save decks to SharedPreferences when adding a new deck
    notifyListeners();
  }

  void removeDeck(Deck deck) {
    final int indexToRemove = _decks.indexOf(deck);
    print('Position of Deck: $indexToRemove');

    if (indexToRemove >= 0) {
      _decks.removeAt(indexToRemove);

      // Check if the number of decks is less than 15 and add a default deck to replace the removed one
      if (_decks.length < 15) {
        final int remainingDefaultDecks = 15 - _decks.length;
        for (int i = 1; i <= remainingDefaultDecks; i++) {
          _addDefaultDeck(indexToRemove, true);
        }
        print(
            'Added $remainingDefaultDecks default decks to replace the removed one.');
      }

      _saveDecks(); // Save decks to SharedPreferences when removing a deck
      notifyListeners();
    }
  }

  // Add any additional methods for managing decks here.
}

// Convenience method to access the DeckProvider instance
DeckProvider deckProvider(BuildContext context) {
  return Provider.of<DeckProvider>(context, listen: false);
}
