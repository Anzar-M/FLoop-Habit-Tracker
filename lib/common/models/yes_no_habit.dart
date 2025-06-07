import 'package:flutter/material.dart';
import 'habit.dart';

class YesNoHabit extends Habit {
  YesNoHabit(String name, String question, Color color)
      : super(name, question, color);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'yes_no',
        'name': name,
        'question': question,
        'color': color.value,
        'dateCreated': dateCreated.toIso8601String(),
        'performance': performance
            .map((date, val) => MapEntry(date.toIso8601String(), val as bool)),
      };

  static YesNoHabit fromJson(Map<String, dynamic> json) {
    final habit = YesNoHabit(
      json['name'],
      json['question'],
      Color(json['color']),
    );
    habit.dateCreated = DateTime.parse(json['dateCreated']);
    habit.performance = (json['performance'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(DateTime.parse(k), v as bool));
    return habit;
  }
}
