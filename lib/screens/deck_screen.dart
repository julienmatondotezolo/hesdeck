import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/widgets/button_widget.dart';

class DeckScreen extends StatelessWidget {
  final Deck deck;

  const DeckScreen({super.key, required this.deck});

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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement adding a new button to the deck.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
