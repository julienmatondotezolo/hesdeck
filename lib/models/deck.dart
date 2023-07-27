import 'package:flutter/material.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/helpers.dart';

class Deck {
  final String name;
  final IconData iconData;
  final LinearGradient? backgroundColor; // Optional background color
  final Color? iconColor; // Optional icon color
  final bool defaultDeck; // Boolean to indicate if the deck is a default deck
  final bool dossierDeck;
  final bool popupDeck;
  final bool clickableDeck;

  Deck({
    required this.name,
    required this.iconData,
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
      'iconData': iconData.codePoint, // Save the icon data (int)
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
      iconData: json['iconData'] != null
          ? IconData(json['iconData'], fontFamily: 'MaterialIcons')
          : Icons.widgets, // Replace with the default icon you want to use
      backgroundColor: json['backgroundColor'] != null
          ? LinearGradient(
              colors: (json['backgroundColor']['colors'] as List<dynamic>)
                  .map<Color>((colorValue) => Color(colorValue))
                  .toList(),
              begin:
                  Helpers.stringToAlignment(json['backgroundColor']['begin']),
              end: Helpers.stringToAlignment(json['backgroundColor']['end']),
            )
          : AppColors.blueToDarkGradient,
      iconColor: json['iconColor'] != null ? Color(json['iconColor']) : null,
      defaultDeck: json['defaultDeck'] ?? false,
      dossierDeck: json['dossierDeck'] ?? false,
      popupDeck: json['popupDeck'] ?? false,
      clickableDeck: json['clickableDeck'] ?? false,
    );
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
