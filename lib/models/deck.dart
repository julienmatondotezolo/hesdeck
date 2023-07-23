import 'package:flutter/material.dart';
import 'package:hessdeck/models/button.dart';

class Deck {
  final String name;
  final IconData iconData;
  final List<DeckButton> buttons;
  bool isFavorite;

  Deck({
    required this.name,
    required this.iconData,
    required this.buttons,
    this.isFavorite = false,
  });

  // Add any additional methods or functionality for the Deck class.
}

class Button {
  // Define properties for the Button class here.
  // For example, you can have properties like button label, icon, action, etc.
}
