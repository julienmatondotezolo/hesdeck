import 'package:flutter/material.dart';
import 'package:my_mobile_deck/models/deck.dart';
import 'package:my_mobile_deck/services/actions/manage_actions.dart';
import 'package:my_mobile_deck/themes/colors.dart';
import 'package:my_mobile_deck/utils/helpers.dart';

class PopupDeckWidget extends StatelessWidget {
  final Deck? deck; // Deck can be null
  final BuildContext context; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list
  final int? folderIndex;

  const PopupDeckWidget({
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
        deck!.action.isNotEmpty
            ? ManageAcions.selectAction(
                context,
                deck!.actionConnectionType,
                deck!.action,
                deck!.actionParameter,
              )
            : null;
      },
      onDoubleTap: () {
        Helpers.openDeckSettingsScreen(
          context,
          deckIndex,
          deck!,
          folderIndex,
        );
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
                color: Colors.white,
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
