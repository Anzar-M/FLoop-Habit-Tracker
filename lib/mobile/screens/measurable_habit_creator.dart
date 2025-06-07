import 'package:flutter/material.dart';
import '../../common/models/measurable_habit.dart';
import '../widgets/color_picker_widget.dart';
import '../../common/storage/habit_storage.dart';

class MeasurableHabitCreatorPage extends StatefulWidget {
  @override
  _MeasurableHabitCreatorPageState createState() =>
      _MeasurableHabitCreatorPageState();
}

class _MeasurableHabitCreatorPageState
    extends State<MeasurableHabitCreatorPage> {
  final _nameCtrl = TextEditingController();
  final _questionCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  Color _selectedColor = Colors.blue;


  @override
  void dispose() {
    _nameCtrl.dispose();
    _questionCtrl.dispose();
    _targetCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }


  String _frequency = 'Every Day';
  String _targetType = 'At least';

  final List<String> _frequencies = ['Every Day', 'Every Week', 'Every Month'];
  final List<String> _targetTypes = ['At least', 'At most'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Measurable Habit"),
          actions: [
            OutlinedButton(
              onPressed: _saveHabit,
              child: Text("SAVE", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Habit Name',
                        hintText: 'e.g. Read',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ColorPickerWidget(
                    initialColor: _selectedColor,
                    onColorChanged: (color) {
                      setState(() => _selectedColor = color);
                    },
                  ),
                ],
              ),

              SizedBox(height: 16),

              TextField(
                controller: _questionCtrl,
                decoration: InputDecoration(
                  labelText: 'Question',
                  hintText: 'e.g. How many pages did you read?',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _unitCtrl,
                decoration: InputDecoration(
                  labelText: 'Unit (e.g. pages, km)',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _targetCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Target Value',
                  hintText: 'e.g. 10',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _frequency,
                items: _frequencies
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _frequency = v!),
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _targetType,
                items: _targetTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _targetType = v!),
                decoration: InputDecoration(
                  labelText: 'Target Type',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    final name = _nameCtrl.text.trim();
    final question = _questionCtrl.text.trim();
    final targetStr = _targetCtrl.text.trim();
    final unit = _unitCtrl.text.trim();

    if (name.isEmpty ||
        question.isEmpty ||
        targetStr.isEmpty ||
        unit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final target = double.tryParse(targetStr);
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid target value')),
      );
      return;
    }

    final habit = MeasurableHabit(
      name,
      question,
      _selectedColor,
      target,
      unit,
      frequency: _frequency,
      targetType: _targetType,
    );

    final added = HabitStorage.addHabit(habit);
    if (await added) {
    if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A habit with that name already exists')),
      );
    }
  }
}