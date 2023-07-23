import 'package:flutter/material.dart';

import '../models/button.dart';

class ButtonProvider extends ChangeNotifier {
  final List<DeckButton> _buttons = []; // Initial empty list of buttons

  List<DeckButton> get buttons => _buttons;

  void addButton(DeckButton button) {
    _buttons.add(button);
    notifyListeners();
  }

  void removeButton(DeckButton button) {
    _buttons.remove(button);
    notifyListeners();
  }

  // Add any additional methods for managing buttons here.
}
