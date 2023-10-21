import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/services/decks/process_decks.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:provider/provider.dart';

class DeckGridWidget extends StatelessWidget {
  const DeckGridWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridViewKey = GlobalKey();
    return Consumer<DeckProvider>(builder: (context, deckProvider, child) {
      List<Deck> deckList = Provider.of<DeckProvider>(context).decks;

      final generatedChildren = List.generate(deckList.length, (index) {
        Deck deck = deckList[index];
        return DeckWidget(
          key: ValueKey(index),
          deck: deck,
          homeScreenContext: context,
          deckIndex: index,
        );
      });

      if (deckList.isNotEmpty) {
        return ReorderableBuilder(
          children: generatedChildren,
          onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
            // Create a copy of the deck list
            List<Deck> updatedDeckList = List.from(deckList);

            for (final orderUpdateEntity in orderUpdateEntities) {
              int newIndex = orderUpdateEntity.newIndex;
              int oldIndex = orderUpdateEntity.oldIndex;

              // Get the deck that is being moved
              Deck movedDeck = updatedDeckList.removeAt(oldIndex);

              // Insert the moved deck at the new index
              updatedDeckList.insert(newIndex, movedDeck);
            }

            ProcessDecks.dragDecks(context, updatedDeckList);
          },
          builder: (children) {
            return GridView(
              key: gridViewKey,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio:
                    1, // Aspect ratio of each grid item (width/height)
              ),
              children: children,
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
