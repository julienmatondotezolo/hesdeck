import 'package:flutter/material.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/helpers.dart';

class Deck {
  final String name;
  final String action;
  final String actionConnectionType;
  final String? actionParameter;
  final IconData iconData;
  final LinearGradient? backgroundColor; // Optional background color
  final LinearGradient? activeBackgroundColor; //
  final Color? iconColor; // Optional icon color
  final bool defaultDeck; // Boolean to indicate if the deck is a default deck
  final bool dossierDeck;
  final bool popupDeck;
  final bool clickableDeck;
  final List<Deck>? content;

  Deck({
    required this.name,
    required this.action,
    required this.actionConnectionType,
    this.actionParameter,
    required this.iconData,
    this.backgroundColor = AppColors.blueToGreyGradient,
    this.activeBackgroundColor = AppColors.activeBlueToDarkGradient,
    this.iconColor = AppColors.lightGrey,
    this.defaultDeck = false, // Default value is false for custom decks
    this.dossierDeck = false,
    this.popupDeck = false,
    this.clickableDeck = false,
    this.content,
  }) : assert(
          _checkSingleType(
            defaultDeck,
            dossierDeck,
            popupDeck,
            clickableDeck,
          ),
          "A deck can only be type.",
        );

  Deck copyWith({
    String? name,
    String? action,
    String? actionConnectionType,
    String? actionParameter,
    IconData? iconData,
    LinearGradient? backgroundColor,
    LinearGradient? activeBackgroundColor,
    Color? iconColor,
    bool? defaultDeck,
    bool? dossierDeck,
    bool? popupDeck,
    bool? clickableDeck,
    List<Deck>? content,
  }) {
    return Deck(
      name: name ?? this.name,
      action: action ?? this.action,
      actionConnectionType: actionConnectionType ?? this.actionConnectionType,
      actionParameter: actionParameter ?? this.actionParameter,
      iconData: iconData ?? this.iconData,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeBackgroundColor:
          activeBackgroundColor ?? this.activeBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      defaultDeck: defaultDeck ?? this.defaultDeck,
      dossierDeck: dossierDeck ?? this.dossierDeck,
      popupDeck: popupDeck ?? this.popupDeck,
      clickableDeck: clickableDeck ?? this.clickableDeck,
      content: content ?? this.content,
    );
  }

  // Method to convert Deck object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'action': action,
      'actionConnectionType': actionConnectionType,
      'actionParameter': actionParameter,
      'iconData': iconData.codePoint, // Save the icon data (int)
      'backgroundColor': backgroundColor != null
          ? {
              'colors':
                  backgroundColor!.colors.map((color) => color.value).toList(),
              'begin': backgroundColor!.begin.toString(),
              'end': backgroundColor!.end.toString(),
            }
          : null,
      'activeBackgroundColor': activeBackgroundColor != null
          ? {
              'colors': activeBackgroundColor!.colors
                  .map((color) => color.value)
                  .toList(),
              'begin': activeBackgroundColor!.begin.toString(),
              'end': activeBackgroundColor!.end.toString(),
            }
          : null,
      'iconColor': iconColor?.value,
      'defaultDeck': defaultDeck,
      'dossierDeck': dossierDeck,
      'popupDeck': popupDeck,
      'clickableDeck': clickableDeck,
      'content': content != null
          ? content!
              .map((deck) => deck.toJson())
              .toList() // Convert content decks to JSON
          : null,
    };
  }

  // Factory method to create a Deck object from a JSON map
  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      name: json['name'],
      action: json['action'],
      actionConnectionType: json['actionConnectionType'],
      actionParameter: json['actionParameter'],
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
      activeBackgroundColor: json['activeBackgroundColor'] != null
          ? LinearGradient(
              colors: (json['activeBackgroundColor']['colors'] as List<dynamic>)
                  .map<Color>((colorValue) => Color(colorValue))
                  .toList(),
              begin: Helpers.stringToAlignment(
                  json['activeBackgroundColor']['begin']),
              end: Helpers.stringToAlignment(
                  json['activeBackgroundColor']['end']),
            )
          : AppColors.activeBlueToDarkGradient,
      iconColor: json['iconColor'] != null
          ? Color(json['iconColor'])
          : AppColors.lightGrey,
      defaultDeck: json['defaultDeck'] ?? false,
      dossierDeck: json['dossierDeck'] ?? false,
      popupDeck: json['popupDeck'] ?? false,
      clickableDeck: json['clickableDeck'] ?? false,
      content: json['content'] != null
          ? (json['content'] as List<dynamic>)
              .map((deckJson) => Deck.fromJson(deckJson))
              .toList() // Convert content JSON to List of Decks
          : null,
    );
  }

  // Check if only one type is set to true
  static bool _checkSingleType(
    bool defaultDeck,
    bool dossierDeck,
    bool popupDeck,
    bool clickableDeck,
  ) {
    int trueCount = 0;
    if (defaultDeck) trueCount++;
    if (dossierDeck) trueCount++;
    if (popupDeck) trueCount++;
    if (clickableDeck) trueCount++;

    return trueCount <= 1;
  }
}
