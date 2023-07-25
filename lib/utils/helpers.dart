import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/screens/deck_screen.dart';
import 'package:hessdeck/themes/colors.dart';

class Helpers {
  // Function to show a dialog
  static void showAddDeckDialog(BuildContext context, int deckIndex) {
    // Get the screen height using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;

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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05, // 5% of the screen height
                ),
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
                    title: const Text(
                      'OBS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      GestureDetector(
                        onTap: () {
                          customDialog(context, 'Adding "" to deck');
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top:
                                  BorderSide(color: Colors.white10, width: 1.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 26.0),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'OBS Content',
                              style: TextStyle(
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

  static void customDialog(BuildContext context, String message) {
    final deckNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: TextField(
            controller: deckNameController,
            decoration: InputDecoration(labelText: message),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // static void updateDeck(BuildContext context, int deckIndex, Deck deck) {
  //   bool deckClickToggle = deck.clicked == true ? false : true;
  //   final deckProvider = Provider.of<DeckProvider>(context, listen: false);
  //   final updatedDeck = deck.copyWith(
  //     clicked: deckClickToggle, // Mark the deck as active
  //     backgroundColor: deckClickToggle
  //         ? AppColors.activeBlueToDarkGradient
  //         : AppColors.blueToGreyGradient,
  //   );
  //   deckProvider.updateDeck(updatedDeck, deckIndex);
  // }

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

  LinearGradient deckGradient() {
    return AppColors.blueToDarkGradient;
  }
}
