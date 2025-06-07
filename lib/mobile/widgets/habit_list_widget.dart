import 'package:flutter/material.dart';
import '../../common/themes/app_theme.dart';

import '../../common/models/habit.dart';
import '../screens/habit_visualization_screen.dart';

class HabitListWidget extends StatelessWidget {
  final List<Habit> habits;
  final Set<Habit> selectedHabits;
  final Function(Habit) onHabitToggle;

  const HabitListWidget({
    Key? key,
    required this.habits,
    required this.selectedHabits,
    required this.onHabitToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 45,
          width: 100,
          alignment: Alignment.center,
          child: Text(
            "Habits",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        ...habits.map((habit) {
          final selected = selectedHabits.contains(habit);
          return GestureDetector(
            onLongPress: () => onHabitToggle(habit),
            child: Container(
              height: 60,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? (isDark ? AppColors.habitName : Colors.yellow)
                    : Colors.transparent,
              ),
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HabitVisualizationScreen(habit: habit),
                  ),
                ),
                child: Text(
                  habit.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: habit.color),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}