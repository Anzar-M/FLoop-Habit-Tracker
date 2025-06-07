import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../../../common/models/yes_no_habit.dart';

class YesNoHeatmap extends StatelessWidget {
  final YesNoHabit habit;
  final int selectedMonth;
  final int year;

  const YesNoHeatmap({
    Key? key,
    required this.habit,
    required this.selectedMonth,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final data = <DateTime, int>{};

    habit.performance.forEach((date, perf) {
      if (date.year == year && date.month == selectedMonth && perf == true) {
        data[date] = 1;
      }
    });
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(height: 8),
        Container(
          width: width,
          child: HeatMap(
            datasets: data,
            colorMode: ColorMode.color,
            defaultColor: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            textColor: isDark ? Colors.white : Colors.black,
            showColorTip: false,
            showText: true,
            scrollable: false,
            size: width / 7,
            colorsets: {1: habit.color},
            startDate: DateTime(year, selectedMonth, 1),
            endDate: DateTime(year, selectedMonth + 1, 0),
          ),
        ),
      ],
    );
  }
}