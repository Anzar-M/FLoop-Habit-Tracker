import 'package:flutter/material.dart';
import 'habit.dart';

class MeasurableHabit extends Habit {
  double target;
  String unit;
  String frequency;
  String targetType;

  MeasurableHabit(
    String name,
    String question,
    Color color,
    this.target,
    this.unit, {
    this.frequency = 'Every Day',
    this.targetType = 'At least',
  }) : super(name, question, color);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'measurable',
        'name': name,
        'question': question,
        'color': color.value,
        'dateCreated': dateCreated.toIso8601String(),
        'unit': unit,
        'target': target,
        'frequency': frequency,
        'targetType': targetType,
        'performance': performance.map(
            (date, val) => MapEntry(date.toIso8601String(), val as double)),
      };

  static MeasurableHabit fromJson(Map<String, dynamic> json) {
    final habit = MeasurableHabit(
      json['name'],
      json['question'],
      Color(json['color']),
      (json['target'] as num).toDouble(),
      json['unit'],
      frequency: json['frequency'] ?? 'Every Day',
      targetType: json['targetType'] ?? 'At least',
    );
    habit.dateCreated = DateTime.parse(json['dateCreated']);
    habit.performance = (json['performance'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(DateTime.parse(k), (v as num).toDouble()));
    return habit;
  }

  bool isInSamePeriod(DateTime a, DateTime b) {
    switch (frequency) {
      case 'Every Week':
        return isSameWeek(a, b);
      case 'Every Month':
        return isSameMonth(a, b);
      case 'Every Day':
      default:
        return isSameDay(a, b);
    }
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isSameWeek(DateTime a, DateTime b) {
    final mondayA = a.subtract(Duration(days: a.weekday - 1));
    final mondayB = b.subtract(Duration(days: b.weekday - 1));
    return isSameDay(mondayA, mondayB);
  }

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}
