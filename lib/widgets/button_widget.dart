import 'package:flutter/material.dart';
import 'package:hessdeck/models/button.dart';

class ButtonWidget extends StatelessWidget {
  final DeckButton button;
  final Function() onPressed;

  const ButtonWidget(
      {super.key, required this.button, required this.onPressed});

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
              button.iconData,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              button.label,
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
