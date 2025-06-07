import 'package:flutter/material.dart';
import '../../common/themes/app_theme.dart';

class DateHeaderWidget extends StatelessWidget {
  final List<DateTime> dates;

  const DateHeaderWidget({
    Key? key,
    required this.dates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: dates.map((date) {
        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;
        final dayName = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][
        date.weekday - 1];

        return Container(
          width: 60,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday
                ? (isDark ? AppColors.header : Colors.yellow)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            "$dayName\n${date.day}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday
                  ? (isDark ? Colors.white : Colors.black)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}