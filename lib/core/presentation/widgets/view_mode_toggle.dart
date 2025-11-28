import 'package:flutter/material.dart';

enum ViewMode { grid, list }

class ViewModeToggle extends StatelessWidget {
  const ViewModeToggle({
    required this.currentMode,
    required this.onModeChanged,
    super.key,
  });

  final ViewMode currentMode;
  final ValueChanged<ViewMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ViewMode>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment<ViewMode>(
          value: ViewMode.grid,
          icon: Icon(Icons.grid_view),
          tooltip: 'Grid view',
        ),
        ButtonSegment<ViewMode>(
          value: ViewMode.list,
          icon: Icon(Icons.view_list),
          tooltip: 'List view',
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ViewMode> newSelection) {
        onModeChanged(newSelection.first);
      },
    );
  }
}
