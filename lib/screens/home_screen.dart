import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/screens/deck_screen.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Function to show a dialog for adding a new deck
  void _showAddDeckDialog(BuildContext context) {
    final deckNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Deck'),
          content: TextField(
            controller: deckNameController,
            decoration: const InputDecoration(labelText: 'Deck Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (deckNameController.text.isNotEmpty) {
                  final newDeck = Deck(
                    name: deckNameController.text,
                    iconData: Icons.widgets,
                    buttons: [], // Replace with the desired icon
                  );
                  Provider.of<DeckProvider>(context, listen: false)
                      .addDeck(newDeck);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeckScreen(deck: deck),
                ),
              );
            },
            homeScreenContext: context, // Pass the HomeScreen's context
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
}
