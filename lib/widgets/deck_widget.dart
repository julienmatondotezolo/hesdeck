import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/themes/colors.dart';

class DeckWidget extends StatelessWidget {
  final Deck? deck; // Deck can be null
  final VoidCallback onPressed;
  final BuildContext homeScreenContext; // Pass the HomeScreen's context

  const DeckWidget({
    Key? key,
    required this.deck,
    required this.onPressed,
    required this.homeScreenContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deck!.defaultDeck) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            gradient: AppColors.blueToDarkGradient,
            border: Border.all(color: AppColors.darkGrey, width: 5),
            borderRadius: BorderRadius.circular(10.0),
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: Text(
              deck?.name ?? "Add",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: AppColors.blueToDarkGradient,
                border: Border.all(color: AppColors.darkGrey, width: 3),
                borderRadius: BorderRadius.circular(10.0),
                shape: BoxShape
                    .rectangle, // Use BoxShape.rectangle to add a rounded border
              ),
              child: Center(
                child: Icon(
                  deck!.iconData,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              deck?.name ?? "Add name to deck",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }
  }
}
