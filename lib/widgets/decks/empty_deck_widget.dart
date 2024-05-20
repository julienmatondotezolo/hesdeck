import 'package:flutter/material.dart';
import 'package:my_mobile_deck/models/deck.dart';
import 'package:my_mobile_deck/themes/colors.dart';
import 'package:my_mobile_deck/utils/helpers.dart';

class EmptyDeckWidget extends StatelessWidget {
  final Deck? deck; // Deck can be null
  final BuildContext context; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list
  final int? folderIndex;

  const EmptyDeckWidget({
    Key? key,
    required this.deck,
    required this.context,
    required this.deckIndex,
    this.folderIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helpers.vibration();
        Helpers.showAddDeckDialog(context, deckIndex, folderIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: deck!.backgroundColor,
          border: Border.all(color: AppColors.darkGrey, width: 5),
          borderRadius: BorderRadius.circular(10.0),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Icon(
                deck!.iconData,
                color: deck!.iconColor,
                size: 48.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              deck!.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
