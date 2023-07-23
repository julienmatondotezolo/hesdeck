import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';

class DeckWidget extends StatelessWidget {
  final Deck deck;
  final Function() onPressed;

  const DeckWidget({super.key, required this.deck, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              deck.iconData,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              deck.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
