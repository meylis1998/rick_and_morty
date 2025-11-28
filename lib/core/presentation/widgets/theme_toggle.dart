import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/theme/app_theme.dart';
import 'package:rick_and_morty/core/theme/theme_cubit.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return ThemeSwitcher(
          builder: (context) {
            return IconButton(
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              tooltip: themeMode == ThemeMode.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
              onPressed: () {
                final themeCubit = context.read<ThemeCubit>();

                final newTheme = themeCubit.state == ThemeMode.dark
                    ? AppTheme.lightTheme()
                    : AppTheme.darkTheme();

                ThemeSwitcher.of(context).changeTheme(
                  theme: newTheme,
                  isReversed: themeCubit.state == ThemeMode.light,
                );

                themeCubit.toggleTheme();
              },
            );
          },
        );
      },
    );
  }
}
