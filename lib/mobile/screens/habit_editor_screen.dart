import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../../common/models/habit.dart';
import '../../common/models/measurable_habit.dart';
import '../../common/storage/habit_storage.dart';

class HabitEditScreen extends StatefulWidget {
  final Habit habit;
  HabitEditScreen({required this.habit});

  @override
  _HabitEditScreenState createState() => _HabitEditScreenState();
}

class _HabitEditScreenState extends State<HabitEditScreen> {
  late TextEditingController _habitNameController;
  late TextEditingController _questionController;
  late Color _selectedColor;

  TextEditingController? _targetController;
  TextEditingController? _unitController;
  String? _frequency;
  String? _targetType;
  final List<String> _frequencies = ['Every Day', 'Every Week', 'Every Month'];
  final List<String> _targetTypes = ['At least', 'At most'];

  bool get isMeasurable => widget.habit is MeasurableHabit;

  @override
  void initState() {
    super.initState();

    _habitNameController = TextEditingController(text: widget.habit.name);
    _questionController = TextEditingController(text: widget.habit.question);
    _selectedColor = widget.habit.color;

    if (isMeasurable) {
      final m = widget.habit as MeasurableHabit;
      _targetController = TextEditingController(text: m.target.toString());
      _unitController = TextEditingController(text: m.unit);
      _frequency = m.frequency;
      _targetType = m.targetType;
    }
  }

  void _saveChanges() {
    final name = _habitNameController.text.trim();
    final question = _questionController.text.trim();

    if (name.isEmpty || question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Save common fields
    widget.habit.name = name;
    widget.habit.question = question;
    widget.habit.color = _selectedColor;

    if (isMeasurable) {
      final targetText = _targetController!.text.trim();
      final unitText = _unitController!.text.trim();

      if (targetText.isEmpty || unitText.isEmpty || _frequency == null || _targetType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all measurable fields")),
        );
        return;
      }

      final targetValue = double.tryParse(targetText);
      if (targetValue == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Target must be a valid number")),
        );
        return;
      }

      final m = widget.habit as MeasurableHabit;
      m.target = targetValue;
      m.unit = unitText;
      m.frequency = _frequency!;
      m.targetType = _targetType!;
    }

    HabitStorage.saveHabitsToFile();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Habit'),
          actions: [
            OutlinedButton(
              onPressed: _saveChanges,
              child: Text('SAVE', style: TextStyle(color: isDark? Colors.white : Colors.black)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _habitNameController,
                      decoration: InputDecoration(
                        labelText: 'Habit Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ColorIndicator(
                    width: 48,
                    height: 48,
                    color: _selectedColor,
                    onSelect: () async {
                      final newColor = await showColorPickerDialog(
                        context,
                        _selectedColor,
                        pickersEnabled: { ColorPickerType.wheel: true },
                      );
                      setState(() {
                        _selectedColor = newColor;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 16),

              TextField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),

              // Show measurable habit fields only if applicable
              if (isMeasurable) ...[
                SizedBox(height: 16),
                TextField(
                  controller: _targetController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Target Value',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _unitController,
                  decoration: InputDecoration(
                    labelText: 'Unit (e.g. km, pages)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                  items: _frequencies
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) => setState(() => _frequency = val),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _targetType,
                  decoration: InputDecoration(
                    labelText: 'Target Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _targetTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() => _targetType = val),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
