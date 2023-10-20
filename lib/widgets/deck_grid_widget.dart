import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/widgets/deck_widget.dart';

class DeckGridWidget extends StatelessWidget {
  final List<Deck>? deckList; // Deck can be null

  const DeckGridWidget({
    Key? key,
    required this.deckList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deckList != null) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 1, // Aspect ratio of each grid item (width/height)
        ),
        itemCount: deckList.length,
        itemBuilder: (context, index) {
          final deck = deckList[index];

          return DragTarget<Deck>(
            onWillAccept: (data) {
              // Specify the logic to determine if the drop is allowed or not.
              // For example, you can compare deck properties and return true if it's a valid drop.
              return true;
            },
            onAccept: (data) {
              // Handle the accepted data here.
              // For example, update the deck positions.
              // You can access the index variable to know where the item was dropped.
              // Update the deck positions using setState or your preferred state management solution.
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<Deck>(
                data: deck,
                feedback: SizedBox(
                  width: 120,
                  height: 120,
                  child: DeckWidget(
                    deck: deck,
                    homeScreenContext: context,
                    deckIndex: index,
                  ),
                ),
                childWhenDragging: const SizedBox(),
                child: DeckWidget(
                  deck: deck,
                  homeScreenContext: context, // Pass the HomeScreen's context
                  deckIndex: index, // Pass the index to DeckWidget
                ),
                onDragStarted: () {
                  // Called when the drag operation starts.
                  // You can add any desired effects or updates here.
                },
                onDragEnd: (details) {
                  // Called when the drag operation ends.
                  // You can add any desired effects or updates here.
                },
              );
            },
          );
        },
      );
    }
    // Display CircularProgressIndicator and loading text when deck is null (loading)
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
  }
}
