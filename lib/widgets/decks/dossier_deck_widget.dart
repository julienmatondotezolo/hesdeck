import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/helpers.dart';

class DossierDeckWidget extends StatelessWidget {
  final Deck? deck; // Deck can be null
  final BuildContext context; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list

  const DossierDeckWidget({
    Key? key,
    required this.deck,
    required this.context,
    required this.deckIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helpers.vibration();
        Helpers.openDeckScreen(context, deckIndex, deck!);
      },
      onDoubleTap: () {
        Helpers.vibration();
        Helpers.openDeckSettingsScreen(context, deckIndex, deck!, null);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: deck!.backgroundColor,
          border: Border.all(color: AppColors.darkGrey, width: 5),
          borderRadius: BorderRadius.circular(10.0),
          shape: BoxShape
              .rectangle, // Use BoxShape.rectangle to add a rounded border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Icon(
                deck!.customIconData ?? deck!.iconData,
                color: deck!.iconColor,
                size: 36.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              deck?.name ?? "Add name to deck",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
