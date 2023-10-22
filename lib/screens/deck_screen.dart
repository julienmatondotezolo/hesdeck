import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/widgets/deck_grid_widget.dart';

class DeckScreen extends StatelessWidget {
  final Deck deck;
  final int deckIndex; // Index of the deck in the list

  const DeckScreen({Key? key, required this.deck, required this.deckIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen height using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            gradient: deck.backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight * 0.02, // 5% of the screen height
              ),
              const Expanded(
                child: DeckGridWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
