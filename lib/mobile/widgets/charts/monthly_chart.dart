import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../common/models/measurable_habit.dart';

class MonthlyChart extends StatelessWidget {
  final MeasurableHabit habit;
  final int year;

  const MonthlyChart({
    Key? key,
    required this.habit,
    required this.year,
  }) : super(key: key);

  static const List<String> monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  @override
  Widget build(BuildContext context) {
    Map<int, double> monthlyAggregates = {};

    habit.performance.forEach((date, value) {
      if (date.year == year && value is double) {
        monthlyAggregates[date.month] =
            (monthlyAggregates[date.month] ?? 0) + value;
      }
    });

    if (monthlyAggregates.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No data for $year (monthly)',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final spots = monthlyAggregates.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final rawMax = max(habit.target, spots.map((s) => s.y).reduce(max));
    final step = (rawMax / 5).ceilToDouble();
    final maxY = _roundUpToStep(rawMax, step);

    const monthSlotWidth = 70.0;
    final chartWidth = 12 * monthSlotWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Monthly Aggregation for $year',
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
                maxX: 12,
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
                      FlSpot(12, habit.target),
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
                        final monthIndex = value.toInt();
                        if (monthIndex < 1 || monthIndex > 12) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          monthNames[monthIndex - 1].substring(0, 3),
                          style: TextStyle(fontSize: 10),
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