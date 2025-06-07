import 'package:flutter/material.dart';
import 'habit_creation_dialog.dart';

enum SortMode { manual, nameAsc, nameDesc, createdDateAsc, createdDateDesc }

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onHabitAdded;
  final SortMode currentSortMode;
  final Function(SortMode) onSortModeChanged;
  final Set selectedHabits;
  final VoidCallback onDeleteSelected;
  final VoidCallback onEditSelected;

  const HomeScreenAppBar({
    Key? key,
    required this.onHabitAdded,
    required this.currentSortMode,
    required this.onSortModeChanged,
    required this.selectedHabits,
    required this.onDeleteSelected,
    required this.onEditSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Habit Tracker'),
      actions: [
        IconButton(
          onPressed: () => HabitCreationDialog.show(context, onHabitAdded),
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
              onSortModeChanged(selected);
            }
          },
          icon: Icon(Icons.filter_list),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDeleteSelected();
            else if (value == 'edit') onEditSelected();
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}