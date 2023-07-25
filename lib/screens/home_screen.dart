import 'package:flutter/material.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deckProvider = Provider.of<DeckProvider>(context);

    print('[PROVIDER DECKS SAVED]: ${deckProvider.decks.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile StreamDeck'), // Replace with your app's title
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Maximum of 3 columns
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 8.0, // Spacing between rows
        ),
        itemCount: deckProvider.decks.length,
        itemBuilder: (context, index) {
          final deck = deckProvider.decks[index];

          return DeckWidget(
            deck: deck,
            homeScreenContext: context, // Pass the HomeScreen's context
            deckIndex: index, // Pass the index to DeckWidget
          );
        },
      ),
    );
  }
}
