import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/providers/deck_provider.dart';
import 'package:hessdeck/services/decks/process_decks.dart';
import 'package:hessdeck/utils/helpers.dart';
import 'package:hessdeck/widgets/deck_widget.dart';
import 'package:hessdeck/widgets/gallery/grid_gallery.dart';
import 'package:provider/provider.dart';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';

class DeckGridWidget extends StatelessWidget {
  final List<Deck>? content;
  final int? folderIndex;

  const DeckGridWidget({
    Key? key,
    this.content,
    this.folderIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckProvider>(builder: (context, deckProvider, child) {
      List<Deck> deckList = content != null && folderIndex != null
          ? (deckProvider.getDeckbyIndex(folderIndex!).content ?? [])
          : deckProvider.decks;

      final List<Widget> galleries = List.generate(
        deckList.length,
        (index) => DeckWidget(
          deck: deckList[index],
          homeScreenContext: context, // Pass the HomeScreen's context
          deckIndex: index, // Pass the index to DeckWidget
          folderIndex: folderIndex,
        ),
      );

      void onReorder(int oldIndex, int newIndex) {
        List<Deck> updatedDeckList = List.from(deckList);

        // Get the deck that is being moved
        Deck movedDeck = updatedDeckList.removeAt(oldIndex);

        // Insert the moved deck at the new index
        updatedDeckList.insert(newIndex, movedDeck);

        ProcessDecks.dragDecks(context, updatedDeckList, folderIndex);
      }

      if (deckList.isNotEmpty) {
        return GridGallery(galleries: galleries);
        // return GridView.builder(
        //   itemBuilder: (context, index) {
        //     final deck = deckList[index];
        //     return DeckWidget(
        //       deck: deck,
        //       homeScreenContext: context, // Pass the HomeScreen's context
        //       deckIndex: index, // Pass the index to DeckWidget
        //       folderIndex: folderIndex,
        //     );
        //   },
        //   itemCount: deckList.length,
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3,
        //     crossAxisSpacing: 20.0,
        //     mainAxisSpacing: 20.0,
        //     childAspectRatio: 1,
        //   ),
        // );
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
