import 'package:flutter/material.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/services/actions/manage_actions.dart';
import 'package:hessdeck/themes/colors.dart';

class AddActionWidget extends StatelessWidget {
  final BuildContext context;
  final Deck deck;

  const AddActionWidget({
    Key? key,
    required this.deck,
    required this.context,
  }) : super(key: key);

  void _showAddActionModal(context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final allActions = ManageAcions.getAllActions();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              decoration: const BoxDecoration(
                gradient: AppColors.blueToGreyGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: AppColors.darkGrey,
                    thickness: 5,
                    indent: 140,
                    endIndent: 140,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03, // 3% of the screen height
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add a action",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  for (var action in allActions.entries)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.darkGrey, // Grey background color
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white10,
                              width: 1.0,
                            ), // Thin white border bottom
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          children: [
                            /*Image.network(
                              action['image'],
                              width: 24,
                            ),
                            const SizedBox(width: 16.0),*/
                            Text(
                              action.key,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showAddActionModal(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey, // Dark grey color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white), // + icon
          SizedBox(width: 8), // Spacing
          Text('Add Action'), // Text
        ],
      ),
    );
  }
}
