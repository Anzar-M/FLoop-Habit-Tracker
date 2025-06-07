import 'habit.dart';
import 'yes_no_habit.dart';
import 'measurable_habit.dart';
/// Fetch habits from json file
class HabitFactory {
  static Habit fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'yes_no':
      case 'YesNoHabit':
        return YesNoHabit.fromJson(json);
      case 'measurable':
        return MeasurableHabit.fromJson(json);
      default:
        throw Exception('Unknown habit type: ${json['type']}');
    }
  }
}