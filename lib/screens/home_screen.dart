import 'package:flutter/material.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deckProvider = Provider.of<DeckProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile StreamDeck'), // Replace with your app's title
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items in each row
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 8.0, // Spacing between rows
        ),
        itemCount: deckProvider.decks.length,
        itemBuilder: (context, index) {
          final deck = deckProvider.decks[index];
          return DeckWidget(
            deck: deck,
            onPressed: () {
              // Navigate to the individual deck screen or perform some other action
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeckDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show a dialog for adding a new deck
  void _showAddDeckDialog(BuildContext context) {
    // ... (rest of the function remains the same)
  }
}
