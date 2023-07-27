import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/themes/colors.dart';

class ClickableDeckWidget extends StatefulWidget {
  final Deck? deck; // Deck can be null
  final BuildContext context; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list

  const ClickableDeckWidget({
    Key? key,
    required this.deck,
    required this.context,
    required this.deckIndex,
  }) : super(key: key);

  @override
  _ClickableDeckWidgetState createState() => _ClickableDeckWidgetState();
}

class _ClickableDeckWidgetState extends State<ClickableDeckWidget> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    print(const Color(0xFF222222).value);
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: isClicked
              ? AppColors.activeBlueToDarkGradient
              : widget.deck!.backgroundColor,
          // gradient: const LinearGradient(
          //   colors: [Color.fromARGB(255, 19, 50, 123), Color(0xFF080A0E)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomLeft,
          // ),
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
                widget.deck!.iconData,
                color: Colors.white,
                size: 36.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.deck?.name ?? "Add name to deck",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
