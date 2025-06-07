import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../common/models/measurable_habit.dart';

class WeeklyChart extends StatelessWidget {
  final MeasurableHabit habit;
  final int year;
  final int month;

  const WeeklyChart({
    Key? key,
    required this.habit,
    required this.year,
    required this.month,
  }) : super(key: key);

  static const List<String> monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  @override
  Widget build(BuildContext context) {
    final totalWeeks = _weeksInMonth(year, month);
    Map<int, double> weeklyAggregates = {};

    habit.performance.forEach((date, value) {
      if (date.year == year && date.month == month && value is double) {
        final weekNum = ((date.day - 1) / 7).floor() + 1;
        weeklyAggregates[weekNum] = (weeklyAggregates[weekNum] ?? 0) + value;
      }
    });

    if (weeklyAggregates.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No data for ${monthNames[month - 1]} (weekly)',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final spots = weeklyAggregates.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final rawMax = max(habit.target, spots.map((s) => s.y).reduce(max));
    final step = (rawMax / 5).ceilToDouble();
    final maxY = _roundUpToStep(rawMax, step);

    const weekSlotWidth = 100.0;
    final chartWidth = totalWeeks * weekSlotWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Weekly Aggregation for ${monthNames[month - 1]}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: chartWidth,
            height: 300,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: totalWeeks.toDouble(),
                minY: 0,
                maxY: maxY + 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: habit.color,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: [
                      FlSpot(1, habit.target),
                      FlSpot(totalWeeks.toDouble(), habit.target),
                    ],
                    isCurved: false,
                    color: Colors.red,
                    barWidth: 2,
                    dashArray: [5, 5],
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      // minIncluded: true,
                      // maxIncluded: true,
                      getTitlesWidget: (value, meta) {
                        final week = value.toInt();
                        if (week < 1 || week > totalWeeks) {
                          return const SizedBox.shrink();
                        }
                        return Text('W$week', style: TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: step,
                      // minIncluded: true,
                      // maxIncluded: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, horizontalInterval: step),
                borderData: FlBorderData(show: true),
                lineTouchData: LineTouchData(enabled: true),
                extraLinesData: ExtraLinesData(horizontalLines: [
                  HorizontalLine(
                    y: habit.target,
                    color: Colors.red.withOpacity(0.5),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  )
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _roundUpToStep(double value, double step) {
    if (step == 0) return value;
    return (value / step).ceil() * step;
  }

  int _weeksInMonth(int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    DateTime firstMonday = firstDayOfMonth.subtract(
        Duration(days: firstDayOfMonth.weekday - 1)
    );

    int weekCount = 0;
    DateTime currentWeekStart = firstMonday;

    while (currentWeekStart.isBefore(lastDayOfMonth) ||
        currentWeekStart.isAtSameMomentAs(lastDayOfMonth)) {
      weekCount++;
      currentWeekStart = currentWeekStart.add(Duration(days: 7));
    }
    return weekCount;
  }
}