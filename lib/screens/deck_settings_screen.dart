import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_mobile_deck/models/deck.dart';
import 'package:my_mobile_deck/screens/home_screen.dart';
import 'package:my_mobile_deck/services/decks/process_decks.dart';
import 'package:my_mobile_deck/utils/helpers.dart';
import 'package:my_mobile_deck/widgets/add_action_widget.dart';
import 'package:my_mobile_deck/widgets/gradient_color_picker.dart';

class DeckSettingsScreen extends StatefulWidget {
  final Deck deck;
  final int deckIndex; // Index of the deck in the list
  final int? folderIndex;

  const DeckSettingsScreen({
    Key? key,
    required this.deck,
    required this.deckIndex,
    this.folderIndex,
  }) : super(key: key);

  @override
  DeckSettingsScreenState createState() => DeckSettingsScreenState();
}

class DeckSettingsScreenState extends State<DeckSettingsScreen> {
  late String _name;
  late String _action;
  late String _actionConnectionType;
  late String? _actionParameter;
  late Color _iconColor;
  late LinearGradient _backgroundColor;
  late LinearGradient _activeBackgroundColor;

  @override
  void initState() {
    super.initState();
    _name = widget.deck.name;
    _action = widget.deck.action;
    _actionConnectionType = widget.deck.actionConnectionType;
    _actionParameter = widget.deck.actionParameter;
    _iconColor = widget.deck.iconColor!;
    _backgroundColor = widget.deck.backgroundColor!;
    _activeBackgroundColor = widget.deck.activeBackgroundColor!;
  }

  void _showGradientPicker(void Function(LinearGradient) onGradientChanged,
      LinearGradient gradient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gradient'),
          content: SingleChildScrollView(
            child: GradientColorPicker(
              width: 300,
              height: 100,
              borderRadius: BorderRadius.circular(5.0),
              colors: gradient.colors,
              begin: gradient.begin,
              end: gradient.end,
              onColorsChanged: (colors, begin, end) {
                setState(() {
                  gradient = LinearGradient(
                    colors: colors,
                    begin: begin,
                    end: end,
                  );
                });
              },
              onGradientChanged: onGradientChanged,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          _name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _name,
                onChanged: (newValue) {
                  setState(() {
                    _name = newValue;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: AddActionWidget(
                  context: context,
                  action: _action,
                  actionConnectionType: _actionConnectionType,
                  actionParameter: _actionParameter,
                  onActionChanged: (String action, String actionConnectionType,
                      String? actionParameter) {
                    setState(() {
                      _action = action;
                      _actionConnectionType = actionConnectionType;
                      _actionParameter = actionParameter;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text(
                  'Icon Color',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CircleAvatar(
                  backgroundColor: _iconColor,
                  radius: 18,
                ),
                onTap: () {
                  Helpers.showColorPicker(context, _iconColor, (color) {
                    setState(() {
                      _iconColor = color;
                    });
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Background Color',
                    style: TextStyle(color: Colors.white)),
                trailing: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    gradient: _backgroundColor,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onTap: () {
                  _showGradientPicker((gradient) {
                    setState(() {
                      _backgroundColor = gradient;
                    });
                  }, _backgroundColor);
                },
              ),
              const SizedBox(height: 16.0),
              widget.deck.clickableDeck == true
                  ? ListTile(
                      title: const Text('Active Background Color',
                          style: TextStyle(color: Colors.white)),
                      trailing: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          gradient: _activeBackgroundColor,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onTap: () {
                        _showGradientPicker((gradient) {
                          setState(() {
                            _activeBackgroundColor = gradient;
                          });
                        }, _activeBackgroundColor);
                      },
                    )
                  : Container(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Deck? updatedDeck;

                  updatedDeck = widget.deck.copyWith(
                    name: _name,
                    action: _action,
                    actionConnectionType: _actionConnectionType,
                    actionParameter: _actionParameter,
                    iconColor: _iconColor,
                    activeBackgroundColor: _activeBackgroundColor,
                    backgroundColor: _backgroundColor,
                  );

                  ProcessDecks.addNewDeck(
                    context,
                    widget.deckIndex,
                    widget.folderIndex,
                    updatedDeck,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Update Deck',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.vibrate();
                  ProcessDecks.removeDeck(
                    context,
                    widget.deckIndex,
                    widget.folderIndex,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Remove Deck',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
