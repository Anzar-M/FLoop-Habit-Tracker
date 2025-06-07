import 'package:flutter/material.dart';

import '../../common/models/habit.dart';
import '../../common/models/measurable_habit.dart';
import '../../common/models/yes_no_habit.dart';
import '../widgets/charts/measurable_chart.dart';
import '../widgets/charts/yes_no_heatmap.dart';

class HabitVisualizationScreen extends StatefulWidget {
  final Habit habit;
  HabitVisualizationScreen({required this.habit});

  @override
  _HabitVisualizationScreenState createState() =>
      _HabitVisualizationScreenState();
}

class _HabitVisualizationScreenState extends State<HabitVisualizationScreen> {
  int _selectedMonth = DateTime.now().month;

  static const List<String> _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final year = DateTime.now().year;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(habit.name), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  habit.question,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedMonth,
                  onChanged: (month) {
                    if (month != null) setState(() => _selectedMonth = month);
                  },
                  items: List.generate(12, (i) {
                    return DropdownMenuItem(
                      value: i + 1,
                      child: Center(child: Text(_monthNames[i])),
                    );
                  }),
                ),
              ),
              SizedBox(height: 24),

              if (habit is YesNoHabit)
                YesNoHeatmap(
                  habit: habit,
                  selectedMonth: _selectedMonth,
                  year: year,
                ),
              if (habit is MeasurableHabit)
                MeasurableChart(
                  habit: habit,
                  selectedMonth: _selectedMonth,
                  year: year,
                ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}