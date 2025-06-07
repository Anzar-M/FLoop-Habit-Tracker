import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../common/models/measurable_habit.dart';

class DailyChart extends StatelessWidget {
  final MeasurableHabit habit;
  final int year;
  final int month;

  const DailyChart({
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
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Filter & sort entries for this month
    final entries = habit.performance.entries
        .where((e) =>
    e.key.year == year &&
        e.key.month == month &&
        e.value is double)
        .map((e) => _DayValue(e.key.day, e.value as double))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    if (entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No data for ${monthNames[month - 1]}',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final spots = entries.map((dv) => FlSpot(dv.day.toDouble(), dv.value)).toList();

    final rawMax = max(habit.target, spots.map((s) => s.y).reduce(max));
    final step = (rawMax / 5).ceilToDouble();
    final maxY = _roundUpToStep(rawMax, step);

    const daySlotWidth = 40.0;
    final chartWidth = daysInMonth * daySlotWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${monthNames[month - 1]} Progress',
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
                maxX: daysInMonth.toDouble(),
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
                      FlSpot(daysInMonth.toDouble(), habit.target),
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
                        final day = value.toInt();
                        if (day < 1 || day > daysInMonth) {
                          return const SizedBox.shrink();
                        }
                        return Transform.rotate(
                          angle: -pi / 4,
                          child: Text('$day', style: TextStyle(fontSize: 10)),
                        );
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
}

class _DayValue {
  final int day;
  final double value;

  _DayValue(this.day, this.value);
}