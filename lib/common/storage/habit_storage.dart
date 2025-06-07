import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../models/habit_factory.dart';
import '../models/habit.dart';
class HabitStorage {
  static List<Habit> habitsList = [];

  static Future<File> _localFile() async {
    if (Platform.isAndroid) {
      //Currently path is hardcoded in future make it dynamic via user input
      return File('/storage/emulated/0/habits.json');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/habits.json');
    }
  }

  static Future<void> saveHabitsToFile() async {
    try {
      final file = await _localFile();
      final data = habitsList.map((h) => h.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving habits: $e');
    }
  }

  static Future<List<Habit>> fetchHabitsFromFile() async {
    try {
      final file = await _localFile();
      // if file doesn't exist return empty list
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final list = jsonDecode(contents) as List<dynamic>;
      habitsList = list
          .map((j) => HabitFactory.fromJson(j as Map<String, dynamic>))
          .toList();
      return habitsList;
    } catch (e) {
      debugPrint('Error loading habits: $e');
      return [];
    }
  }

  static Future<bool> addHabit(Habit newHabit) async {
    final exists = habitsList.any((h) =>
    h.name.trim().toLowerCase() == newHabit.name.trim().toLowerCase());
    if (exists) return false;

    habitsList.add(newHabit);
    await saveHabitsToFile();
    return true;
  }

  static Future<bool> deleteHabit(Habit habit) async {
    habitsList.removeWhere((h) => h.name == habit.name);
    await saveHabitsToFile();
    return true;
  }
}
