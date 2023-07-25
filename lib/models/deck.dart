import 'package:flutter/material.dart';
import 'package:hessdeck/models/button.dart';
import 'package:hessdeck/themes/colors.dart';

class Deck {
  final String name;
  final IconData iconData;
  final List<DeckButton> buttons;
  final LinearGradient? backgroundColor; // Optional background color
  final Color? iconColor; // Optional icon color
  final bool defaultDeck; // Boolean to indicate if the deck is a default deck
  final bool dossierDeck;
  final bool popupDeck;
  final bool clickableDeck;

  Deck({
    required this.name,
    required this.iconData,
    required this.buttons,
    this.backgroundColor = AppColors.blueToGreyGradient,
    this.iconColor,
    this.defaultDeck = false, // Default value is false for custom decks
    this.dossierDeck = false,
    this.popupDeck = false,
    this.clickableDeck = false,
  }) : assert(
          _checkSingleType(
            defaultDeck,
            dossierDeck,
            popupDeck,
            clickableDeck,
          ),
          "A deck can be only one type.",
        );

  Deck copyWith({
    String? name,
    IconData? iconData,
    List<DeckButton>? buttons,
    LinearGradient? backgroundColor,
    Color? iconColor,
    bool? defaultDeck,
    bool? dossierDeck,
    bool? popupDeck,
    bool? clickableDeck,
  }) {
    return Deck(
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      buttons: buttons ?? this.buttons,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      defaultDeck: defaultDeck ?? this.defaultDeck,
      dossierDeck: dossierDeck ?? this.dossierDeck,
      popupDeck: popupDeck ?? this.popupDeck,
      clickableDeck: clickableDeck ?? this.clickableDeck,
    );
  }

  // Method to convert Deck object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconData':
          iconData.codePoint, // Save the icon data as its code point (int)
      'buttons': buttons,
      'backgroundColor': backgroundColor != null
          ? {
              'colors':
                  backgroundColor!.colors.map((color) => color.value).toList(),
              'begin': backgroundColor!.begin.toString(),
              'end': backgroundColor!.end.toString(),
            }
          : null,
      'iconColor': iconColor?.value,
      'defaultDeck': defaultDeck,
      'dossierDeck': dossierDeck,
      'popupDeck': popupDeck,
      'clickableDeck': clickableDeck,
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
          ? LinearGradient(
              colors: (json['backgroundColor']['colors'] as List<dynamic>)
                  .map<Color>((colorValue) => Color(colorValue))
                  .toList(),
              begin: _stringToAlignment(json['backgroundColor']['begin']),
              end: _stringToAlignment(json['backgroundColor']['end']),
            )
          : null,
      iconColor: json['iconColor'] != null ? Color(json['iconColor']) : null,
      defaultDeck: json['defaultDeck'] ?? false,
      dossierDeck: json['dossierDeck'] ?? false,
      popupDeck: json['popupDeck'] ?? false,
      clickableDeck: json['clickableDeck'] ?? false,
    );
  }

  // Helper method to convert a string to AlignmentGeometry
  static AlignmentGeometry _stringToAlignment(String alignmentString) {
    switch (alignmentString) {
      case 'Alignment.topLeft':
        return Alignment.topLeft;
      case 'Alignment.topCenter':
        return Alignment.topCenter;
      case 'Alignment.topRight':
        return Alignment.topRight;
      case 'Alignment.centerLeft':
        return Alignment.centerLeft;
      case 'Alignment.center':
        return Alignment.center;
      case 'Alignment.centerRight':
        return Alignment.centerRight;
      case 'Alignment.bottomLeft':
        return Alignment.bottomLeft;
      case 'Alignment.bottomCenter':
        return Alignment.bottomCenter;
      case 'Alignment.bottomRight':
        return Alignment.bottomRight;
      default:
        // If the string doesn't match any of the predefined alignments,
        // you can return a default alignment or throw an exception, depending on your use case.
        return Alignment.center;
    }
  }

  // Check if only one type is set to true
  static bool _checkSingleType(
      bool defaultDeck, bool dossierDeck, bool popupDeck, bool clickableDeck) {
    int trueCount = 0;
    if (defaultDeck) trueCount++;
    if (dossierDeck) trueCount++;
    if (popupDeck) trueCount++;
    if (clickableDeck) trueCount++;

    return trueCount <= 1;
  }
}
