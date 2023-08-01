import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/screens/deck_screen.dart';
import 'package:hessdeck/screens/deck_settings_screen.dart';
import 'package:hessdeck/services/api_services.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:provider/provider.dart';

class Helpers {
  // Function to show a dialog
  static void showAddDeckDialog(BuildContext context, int deckIndex) {
    // Get the screen height using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;

    List<dynamic> data = []; // Initialize data as an empty list

    // Function to fetch data from the API
    Future<void> fetchData() async {
      try {
        List<dynamic> actionData = await ApiServices.fetchActions('data.json');
        data = actionData; // Update the data list with the fetched data
        // You can add further logic or processing here if needed
      } catch (error) {
        // Handle any errors that occur during the data fetching process
        print('Error fetching data: $error');
      }
    }

    fetchData();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      backgroundColor: const Color(0xFF262626),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            decoration: const BoxDecoration(
              gradient: AppColors.blueToGreyGradient,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  color: AppColors.darkGrey,
                  thickness: 5,
                  indent: 140,
                  endIndent: 140,
                ),
                SizedBox(
                  height: screenHeight * 0.03, // 3% of the screen height
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add actions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05, // 5% of the screen height
                ),
                for (var item in data)
                  Container(
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
                              openDeckSettingsScreen(context, deckIndex,
                                  Deck.fromJson(actionDeck));
                              // customDialog(
                              //   context,
                              //   'Add this ${actionDeck["name"]} action.',
                              //   deckIndex,
                              //   actionDeck,
                              // );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.white10, width: 1.0),
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
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void customDialog(
      BuildContext context, String message, int deckIndex, dynamic actionDeck) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newDeck = Deck.fromJson(actionDeck);

                Provider.of<DeckProvider>(context, listen: false)
                    .addDeck(newDeck, deckIndex);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to convert a string to AlignmentGeometry
  static AlignmentGeometry stringToAlignment(String alignmentString) {
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

  static void addNewDeck(BuildContext context, int deckIndex, Deck deck) {
    final newDeck = deck;

    Provider.of<DeckProvider>(context, listen: false)
        .addDeck(newDeck, deckIndex);
    Navigator.pop(context);
  }

  static void updateDeck(BuildContext context, int deckIndex, Deck deck) {
    bool deckClickToggle = deck.clickableDeck == true ? false : true;
    final deckProvider = Provider.of<DeckProvider>(context, listen: false);
    final updatedDeck = deck.copyWith(
      backgroundColor: deckClickToggle
          ? AppColors.activeBlueToDarkGradient
          : AppColors.blueToGreyGradient,
    );
    deckProvider.updateDeck(updatedDeck, deckIndex);
  }

  static void openDeckScreen(BuildContext context, int deckIndex, Deck deck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckScreen(
          deck: deck, // Provide a default value for deck
          deckIndex: deckIndex,
        ),
      ),
    );
  }

  static void openDeckSettingsScreen(
      BuildContext context, int deckIndex, Deck deck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckSettingsScreen(
          deck: deck, // Provide a default value for deck
          deckIndex: deckIndex,
        ),
      ),
    );
  }

  static void showColorPicker(
      BuildContext context, Color color, void Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: onColorChanged,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  LinearGradient deckGradient() {
    return AppColors.blueToDarkGradient;
  }
}
