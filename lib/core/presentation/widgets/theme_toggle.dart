import 'package:flutter/material.dart';
import 'package:rick_and_morty/main.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    if (appState == null) return const SizedBox.shrink();

    final currentTheme = appState.currentThemeMode;

    return PopupMenuButton<ThemeMode>(
      icon: Icon(_getThemeIcon(currentTheme)),
      tooltip: 'Change theme',
      onSelected: appState.changeThemeMode,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(
                currentTheme == ThemeMode.light
                    ? Icons.check
                    : Icons.check_box_outline_blank,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.light_mode, size: 20),
              const SizedBox(width: 8),
              const Text('Light'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(
                currentTheme == ThemeMode.dark
                    ? Icons.check
                    : Icons.check_box_outline_blank,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.dark_mode, size: 20),
              const SizedBox(width: 8),
              const Text('Dark'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(
                currentTheme == ThemeMode.system
                    ? Icons.check
                    : Icons.check_box_outline_blank,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.brightness_auto, size: 20),
              const SizedBox(width: 8),
              const Text('System'),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
