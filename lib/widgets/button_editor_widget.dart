import 'package:flutter/material.dart';
import 'package:hessdeck/models/button.dart';

class ButtonEditorWidget extends StatelessWidget {
  final DeckButton button;
  // Add any additional properties or callbacks needed for editing the button.

  const ButtonEditorWidget({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    // Implement the widget to edit the button properties.
    // You can use text fields, drop-downs, and other form elements.
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            button.iconData,
            size: 48,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            button.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add form fields for editing the button properties here.
        ],
      ),
    );
  }
}
