import 'package:flutter/material.dart';
import '../../common/storage/habit_storage.dart';
import '../../common/models/yes_no_habit.dart';
import '../widgets/color_picker_widget.dart';

class YesNoHabitCreatorPage extends StatefulWidget {
  const YesNoHabitCreatorPage({super.key});

  @override
  State<YesNoHabitCreatorPage> createState() => _YesNoHabitCreatorPageState();
}

class _YesNoHabitCreatorPageState extends State<YesNoHabitCreatorPage> {
  TextEditingController _habitNameController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  Color _selectedColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Create habit"),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    String habitName = _habitNameController.text.trim();
                    String question = _questionController.text.trim();

                    if (habitName.isEmpty || question.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    YesNoHabit habit = YesNoHabit(_habitNameController.text,
                        _questionController.text, _selectedColor);
                    bool added = await HabitStorage.addHabit(habit);
                    if (!mounted) return;
                    if (added) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A habit with this name already exists.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text("SAVE", style: TextStyle(color: isDark? Colors.white : Colors.black),))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _habitNameController,
                        decoration: InputDecoration(
                          labelText: 'Habit Name',
                          hintText: 'Exercise',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 100)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: ColorPickerWidget(
                        initialColor: _selectedColor,
                        onColorChanged: (Color newColor) {
                          setState(() {
                            _selectedColor = newColor;
                          });
                        },
                        size: 60,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      labelText: 'Question',
                      hintText: 'Did you exercise today?',
                      border:
                      OutlineInputBorder(borderSide: BorderSide(width: 100)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}