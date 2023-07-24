import 'package:flutter/material.dart';
import 'package:hessdeck/models/button.dart';

class Deck {
  final String name;
  final IconData iconData;
  final List<DeckButton> buttons;
  final Color? backgroundColor; // Optional background color
  final Color? iconColor; // Optional icon color
  final bool defaultDeck; // Boolean to indicate if the deck is a default deck

  Deck({
    required this.name,
    required this.iconData,
    required this.buttons,
    this.backgroundColor,
    this.iconColor,
    this.defaultDeck = false, // Default value is false for custom decks
  });

  // Method to convert Deck object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconData':
          iconData.codePoint, // Save the icon data as its code point (int)
      'buttons': buttons,
      'backgroundColor': backgroundColor?.value,
      'iconColor': iconColor?.value,
      'defaultDeck': defaultDeck,
    };
  }

  // Factory method to create a Deck object from a JSON map
  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      name: json['name'],
      iconData: IconData(json['iconData'],
          fontFamily: 'MaterialIcons'), // Reconstruct the IconData
      buttons: List<DeckButton>.from(json['buttons']),
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'])
          : null,
      iconColor: json['iconColor'] != null ? Color(json['iconColor']) : null,
      defaultDeck: json['defaultDeck'] ??
          false, // Set defaultDeck to false if not provided in JSON
    );
  }

  // Add any additional methods or functionality for the Deck class.
}
