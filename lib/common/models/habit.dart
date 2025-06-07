import 'package:flutter/material.dart';
/// Base class for all habit types.
abstract class Habit {
  String name;
  String question;
  Color color;
  DateTime dateCreated;
  Map<DateTime, dynamic> performance;

  Habit(this.name, this.question, this.color)
      : dateCreated = DateTime.now(),
        performance = {};
//NOTE: fromJson is in habit_factory.dart
  Map<String, dynamic> toJson();

  }

