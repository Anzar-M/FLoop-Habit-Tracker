import 'package:flutter/material.dart';
import '../../mobile/screens/measurable_habit_creator.dart';

import '../screens/yes_no_habit_creator.dart';

class HabitCreationDialog {
  static Future<void> show(BuildContext context, VoidCallback onHabitAdded) async {
    await showDialog(
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(BorderSide.none),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final habitAdded = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => YesNoHabitCreatorPage(),
                ),
              );
              if (habitAdded == true) onHabitAdded();
            },
            child: AlertDialog(
              title: Text("Yes Or No"),
              content: Text(
                "e.g. Did you wake up early today? Did you exercise? Did you play chess?",
              ),
            ),
          ),
          OutlinedButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(BorderSide.none),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final habitAdded = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => MeasurableHabitCreatorPage(),
                ),
              );
              if (habitAdded == true) onHabitAdded();
            },
            child: AlertDialog(
              title: Text("Measurable"),
              content: Text(
                "e.g. How many miles did you run today? How many pages did you read?",
              ),
            ),
          ),
        ],
      ),
    );
  }
}