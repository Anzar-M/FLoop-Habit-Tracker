import 'package:flutter/material.dart';

import '../../common/models/habit.dart';
import '../../common/models/measurable_habit.dart';
import '../../common/models/yes_no_habit.dart';

class HabitPerformanceCell extends StatelessWidget {
  final Habit habit;
  final DateTime date;
  final VoidCallback onTap;

  const HabitPerformanceCell({
    Key? key,
    required this.habit,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final val = habit.performance[date];

    Widget cellChild;
    Color bgColor = Colors.transparent;
    Color textColor = Colors.transparent;

    if (habit is YesNoHabit) {
      final done = val == true;
      cellChild = Icon(
        done ? Icons.check : Icons.close,
        color: done ? habit.color : Colors.redAccent,
      );
    } else if (habit is MeasurableHabit) {
      final m = habit as MeasurableHabit;
      final numValue = val as double?;

      if (numValue == null) {
        textColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
      } else {
        final isSpecialFreq = m.frequency == 'Every Week' || m.frequency == 'Every Month';

        if (isSpecialFreq) {
          textColor = m.targetType == 'At least'
              ? habit.color
              : Colors.redAccent;
        } else {
          final meets = m.targetType == 'At least'
              ? numValue >= m.target
              : numValue <= m.target;
          textColor = meets ? habit.color : Colors.redAccent;
        }
      }

      cellChild = Text(
        numValue?.toString() ?? '–',
        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      );
    } else {
      cellChild = SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: cellChild,
      ),
    );
  }
}