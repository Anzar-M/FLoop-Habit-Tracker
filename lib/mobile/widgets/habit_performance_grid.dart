import 'package:flutter/material.dart';
import 'date_header_widget.dart';
import 'habit_performance_cell.dart';

import '../../common/models/habit.dart';

class HabitPerformanceGrid extends StatelessWidget {
  final List<DateTime> dates;
  final List<Habit> habits;
  final Function(int, int) onCellTap;
  final ScrollController scrollController;

  const HabitPerformanceGrid({
    Key? key,
    required this.dates,
    required this.habits,
    required this.onCellTap,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        child: Column(
          children: [
            // Date headers
            DateHeaderWidget(dates: dates),

            // Performance rows
            ...habits.asMap().entries.map((entry) {
              final row = entry.key;
              final habit = entry.value;

              return Row(
                children: dates.asMap().entries.map((de) {
                  final col = de.key;
                  final date = de.value;

                  return HabitPerformanceCell(
                    habit: habit,
                    date: date,
                    onTap: () => onCellTap(row, col),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}