import 'dart:convert';
import 'dart:io';
import 'package:hessdeck/models/deck.dart';
import 'package:path_provider/path_provider.dart';

class DataManager {
  static const String _fileName = "decks.json"; // File name to store decks data

  // Function to save decks to a JSON file
  static Future<void> saveDecks(List<Deck> decks) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    final decksJson = decks.map((deck) => deck.toJson()).toList();
    final jsonString = jsonEncode(decksJson);

    await file.writeAsString(jsonString);
  }

  // Function to load decks from the JSON file
  static Future<List<Deck>> loadDecks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    if (!file.existsSync()) {
      return []; // Return an empty list if the file doesn't exist
    }

    final jsonString = await file.readAsString();
    final List<dynamic> decksJson = jsonDecode(jsonString);

    final decks = decksJson.map((json) => Deck.fromJson(json)).toList();
    return decks;
  }
}
