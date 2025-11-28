import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty/core/di/injection.dart';
import 'package:rick_and_morty/core/navigation/app_router.dart';
import 'package:rick_and_morty/core/services/preferences_service.dart';
import 'package:rick_and_morty/core/theme/app_theme.dart';
import 'package:rick_and_morty/core/theme/theme_cubit.dart';
import 'package:rick_and_morty/core/utils/constants.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  await configureDependencies();

  HydratedBloc.storage = storage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PreferencesService>(
          create: (context) => getIt<PreferencesService>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<ThemeCubit>(),
          ),
          BlocProvider(
            create: (context) => getIt<FavoritesBloc>(),
          ),
          BlocProvider(
            create: (context) =>
                getIt<CharactersBloc>()..add(const LoadCharacters()),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final theme = themeMode == ThemeMode.dark
                ? AppTheme.darkTheme()
                : AppTheme.lightTheme();

            return ThemeProvider(
              initTheme: theme,
              duration: const Duration(milliseconds: 400),
              builder: (_, myTheme) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: AppConstants.appName,
                  theme: myTheme,
                  routerConfig: appRouter,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
