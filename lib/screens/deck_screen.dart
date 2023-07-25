import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/widgets/button_widget.dart';

class DeckScreen extends StatelessWidget {
  final Deck deck;
  final int deckIndex; // Index of the deck in the list

  const DeckScreen({Key? key, required this.deck, required this.deckIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: deck.buttons.length,
              itemBuilder: (context, index) {
                final button = deck.buttons[index];
                return ButtonWidget(
                  button: button,
                  onPressed: () {
                    // Implement the action when the button is tapped.
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.red,
            child: ElevatedButton(
              onPressed: () {
                deckProvider(context).removeDeck(deck, deckIndex);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Remove Deck',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
