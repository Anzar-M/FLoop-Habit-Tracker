import 'package:Floop/mobile/screens/yes_no_habit_creator.dart';
import 'package:flutter/material.dart';

import '../../common/models/habit.dart';
import '../../common/models/measurable_habit.dart';
import '../../common/models/yes_no_habit.dart';
import '../../common/storage/habit_storage.dart';
import 'habit_editor_screen.dart';
import 'habit_visualization_screen.dart';
import '../../common/themes/app_theme.dart';
import 'measurable_habit_creator.dart';


enum SortMode { manual, nameAsc, nameDesc, createdDateAsc, createdDateDesc }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DateTime> dates = [];
  List<Habit> habits = [];
  Set<Habit> selectedHabits = {};
  SortMode _currentSortMode = SortMode.manual;
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initDates();
    _loadHabits();
    _refreshHabits();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  void _initDates() {
    final now = DateTime.now();
// Gets days in current month: next month, day 0 → last day of current month
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    dates = List.generate(daysInMonth, (i) => DateTime(now.year, now.month, i + 1));
  }

  Future<void> _loadHabits() async {
    final fetched = await HabitStorage.fetchHabitsFromFile();
    setState(() => habits = fetched);
  }

  void _refreshHabits() => _loadHabits();

  void _scrollToToday() {
    final today = DateTime.now();
    final idx = dates.indexWhere((d) =>
    d.year == today.year && d.month == today.month && d.day == today.day);
    if (idx != -1) {
      _horizontalScrollController.animateTo(
        idx * 60.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void _sortHabits() {
    setState(() {
      switch (_currentSortMode) {
        case SortMode.nameAsc:
          habits.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          break;
        case SortMode.nameDesc:
          habits.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
          break;
        case SortMode.createdDateAsc:
          habits.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
          break;
        case SortMode.createdDateDesc:
          habits.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
          break;
        case SortMode.manual:
        habits = HabitStorage.habitsList;
      }
    });
  }

  Future<void> _updatePerformance(int rowIndex, int colIndex) async {
    final habit = habits[rowIndex];
    final date = dates[colIndex];

    if (habit is YesNoHabit) {
      final was = habit.performance[date] ?? false;
      habit.performance[date] = !was;
    } else if (habit is MeasurableHabit) {
      final ctrl = TextEditingController(text: habit.performance[date]?.toString() ?? '');
      final entered = await showDialog<double?>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('${habit.unit} on ${date.day}/${date.month}'),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: 'Enter a value'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
            TextButton(
              onPressed: () {
                final v = double.tryParse(ctrl.text.trim());
                Navigator.pop(context, v);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      if (entered != null) {
        habit.performance[date] = entered;
      }
    }

    await HabitStorage.saveHabitsToFile();
    setState(() {});
  }

  void _toggleHabitSelection(Habit habit) {
    setState(() {
      selectedHabits.contains(habit)
          ? selectedHabits.remove(habit)
          : selectedHabits.add(habit);
    });
    HabitStorage.saveHabitsToFile();
  }

  void _deleteSelectedHabits() {
    setState(() {
      habits.removeWhere((h) => selectedHabits.contains(h));
      selectedHabits.clear();
    });
    HabitStorage.saveHabitsToFile();
  }

  Future<void> _editSelectedHabit() async {
    if (selectedHabits.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select only one habit to edit.")),
      );
      return;
    }
    final habit = selectedHabits.first;
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => HabitEditScreen(habit: habit)),
    );
    if (changed == true) _refreshHabits();
    setState(() => selectedHabits.clear());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide.none),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final habitAdded = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(builder: (context) => YesNoHabitCreatorPage()),
                        );
                        if (habitAdded == true) _refreshHabits();
                      },
                      child: AlertDialog(
                        title: Text("Yes Or No"),
                        content: Text(
                            "e.g. Did you wake up early today? Did you exercise? Did you play chess?"),
                      ),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide.none),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final habitAdded = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(builder: (context) => MeasurableHabitCreatorPage()),
                        );
                        if (habitAdded == true) _refreshHabits();
                      },
                      child: AlertDialog(
                        title: Text("Measurable"),
                        content: Text(
                            "e.g. How many miles did you run today? How many pages did you read?"),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              final selected = await showMenu<SortMode>(
                context: context,
                position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: [
                  PopupMenuItem(value: SortMode.manual, child: Text("Manual")),
                  PopupMenuItem(value: SortMode.nameAsc, child: Text("Sort by Name (Asc)")),
                  PopupMenuItem(value: SortMode.nameDesc, child: Text("Sort by Name (Desc)")),
                  PopupMenuItem(value: SortMode.createdDateAsc, child: Text("Sort by Created Date (Asc)")),
                  PopupMenuItem(value: SortMode.createdDateDesc, child: Text("Sort by Created Date (Desc)")),
                ],
              );
              if (selected != null) {
                _currentSortMode = selected;
                _sortHabits();
              }
            },
            icon: Icon(Icons.filter_list),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _deleteSelectedHabits();
              else if (value == 'edit') _editSelectedHabit();
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit Selected'),
                enabled: selectedHabits.length == 1,
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Selected'),
                enabled: selectedHabits.isNotEmpty,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 45,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                  ),
                  child: Text("Habits", style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic )),
                ),
                ...habits.map((habit) {
                  final selected = selectedHabits.contains(habit);
                  return GestureDetector(
                    onLongPress: () => _toggleHabitSelection(habit),
                    child: Container(
                      height: 60,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? (isDark? AppColors.habitName: Colors.yellow) : Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HabitVisualizationScreen(habit: habit)),
                        ),
                        child: Text(
                          habit.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: habit.color),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalScrollController,
                child: Column(
                  children: [
                    // Date headers
                    Row(
                      children: dates.map((date) {
                        final isToday = date.year == DateTime.now().year &&
                            date.month == DateTime.now().month &&
                            date.day == DateTime.now().day;
                        final dayName = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][date.weekday - 1];
                        return Container(
                          width: 60,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isToday ? (isDark ? AppColors.header : Colors.yellow) : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$dayName\n${date.day}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? (isDark ? Colors.white : Colors.black) : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Performance rows
                    ...habits.asMap().entries.map((entry) {
                      final row = entry.key;
                      final habit = entry.value;
                      return Row(
                        children: dates.asMap().entries.map((de) {
                          final col = de.key;
                          final date = de.value;
                          final val = habit.performance[date];
                          Widget cellChild;
                          Color bgColor = Colors.transparent;
                          Color textColor = Colors.transparent;

                          if (habit is YesNoHabit) {
                            final done = val == true;
                            cellChild = Icon(
                              done ? Icons.check : Icons.close,
                              color: done ? habit.color : Colors.redAccent,
                            );

                          } else if (habit is MeasurableHabit) {
                            final m = habit;
                            final numValue = val as double?;


                            final isSpecialFreq = m.frequency == 'Every Week' || m.frequency == 'Every Month';

                            if (numValue == null) {
                              textColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
                            } else if (isSpecialFreq) {
                               textColor = m.targetType == 'At least'
                                   ? habit.color
                                   : Colors.redAccent;

                            } else {
                              final meets = m.targetType == 'At least'
                                  ? numValue >= m.target
                                  : numValue <= m.target;
                              textColor = meets ? habit.color : Colors.redAccent;
                            }

                            cellChild = Text(
                              numValue?.toString() ?? '–',
                              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                            );
                            if (numValue != null) {
                            }

                          } else {
                            cellChild = SizedBox.shrink();
                          }

                          return GestureDetector(
                            onTap: () => _updatePerformance(row, col),
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: bgColor,
                              ),
                              child: cellChild,
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}