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

class _ClickableDeckWidgetState extends State<ClickableDeckWidget>
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
        setState(() {
          isClicked = !isClicked;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
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
              child: Icon(
                widget.deck!.iconData,
                color: widget.deck!.iconColor,
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
