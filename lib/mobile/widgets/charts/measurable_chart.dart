import 'package:flutter/material.dart';

import 'daily_chart.dart';
import 'weekly_chart.dart';
import 'monthly_chart.dart';
import '../../../common/models/measurable_habit.dart';

class MeasurableChart extends StatelessWidget {
  final MeasurableHabit habit;
  final int selectedMonth;
  final int year;

  const MeasurableChart({
    Key? key,
    required this.habit,
    required this.selectedMonth,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (habit.frequency) {
      case 'Every Week':
        return WeeklyChart(habit: habit, year: year, month: selectedMonth);
      case 'Every Month':
        return MonthlyChart(habit: habit, year: year);
      case 'Every Day':
      default:
        return DailyChart(habit: habit, year: year, month: selectedMonth);
    }
  }
}