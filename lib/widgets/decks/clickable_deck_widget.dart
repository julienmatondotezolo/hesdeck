import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/services/actions/manage_actions.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/helpers.dart';

class ClickableDeckWidget extends StatefulWidget {
  final Deck? deck; // Deck can be null
  final BuildContext context; // Pass the HomeScreen's context
  final int deckIndex; // Index of the deck in the list
  final int? folderIndex;

  const ClickableDeckWidget({
    Key? key,
    required this.deck,
    required this.context,
    required this.deckIndex,
    this.folderIndex,
  }) : super(key: key);

  @override
  ClickableDeckWidgetState createState() => ClickableDeckWidgetState();
}

class ClickableDeckWidgetState extends State<ClickableDeckWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 18, 173, 193),
      end: const Color.fromARGB(255, 18, 100, 193),
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helpers.vibration();
        setState(() {
          isClicked = !isClicked;
        });
        isClicked
            ? ManageAcions.selectAction(
                context,
                widget.deck!.actionConnectionType,
                widget.deck!.action,
                widget.deck!.actionParameter,
              )
            : null;
      },
      onDoubleTap: () {
        Helpers.vibration();
        Helpers.openDeckSettingsScreen(
          context,
          widget.deckIndex,
          widget.deck!,
          widget.folderIndex,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isClicked
              ? widget.deck!.activeBackgroundColor
              : widget.deck!.backgroundColor,
          border: Border.all(
            color: isClicked
                ? _colorAnimation.value ?? AppColors.darkGrey
                : AppColors.darkGrey,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(10.0),
          shape: BoxShape
              .rectangle, // Use BoxShape.rectangle to add a rounded border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    widget.deck!.customIconData ?? widget.deck!.iconData,
                    color: widget.deck!.iconColor,
                    size: 36.0,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.deck?.name ?? "Add name to deck",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
