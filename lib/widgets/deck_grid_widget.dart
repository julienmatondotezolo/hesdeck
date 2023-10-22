import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/services/decks/process_decks.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class DeckGridWidget extends StatelessWidget {
  const DeckGridWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckProvider>(builder: (context, deckProvider, child) {
      List<Deck> deckList = Provider.of<DeckProvider>(context).decks;

      void onReorder(int oldIndex, int newIndex) {
        List<Deck> updatedDeckList = List.from(deckList);

        // Get the deck that is being moved
        Deck movedDeck = updatedDeckList.removeAt(oldIndex);

        // Insert the moved deck at the new index
        updatedDeckList.insert(newIndex, movedDeck);

        ProcessDecks.dragDecks(context, updatedDeckList);
      }

      if (deckList.isNotEmpty) {
        return ReorderableGridView.builder(
          // dragEnabled: false,
          dragStartDelay: const Duration(milliseconds: 300),
          dragWidgetBuilder: (index, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: child,
            );
          },
          placeholderBuilder: (dropIndex, dropInddex, dragWidget) {
            return Opacity(
              opacity: 0.5,
              child: dragWidget,
            );
          },
          onReorder: onReorder,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio:
                1, // Aspect ratio of each grid item (width/height)
          ),
          itemCount: deckList.length,
          itemBuilder: (context, index) {
            final deck = deckList[index];
            return DeckWidget(
              key: ValueKey(index),
              deck: deck,
              homeScreenContext: context, // Pass the HomeScreen's context
              deckIndex: index, // Pass the index to DeckWidget
            );
          },
        );
      }

      return Container(
        padding: const EdgeInsets.all(8.0),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Loading Decks...',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    });
  }
}
