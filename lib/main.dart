import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty/core/di/injection.dart';
import 'package:rick_and_morty/core/navigation/app_router.dart';
import 'package:rick_and_morty/core/services/preferences_service.dart';
import 'package:rick_and_morty/core/theme/app_theme.dart';
import 'package:rick_and_morty/core/utils/constants.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_event.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  late PreferencesService _prefsService;

  @override
  void initState() {
    super.initState();
    _prefsService = getIt<PreferencesService>();
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final themeMode = _prefsService.getThemeMode();
    setState(() {
      switch (themeMode) {
        case 'light':
          _themeMode = ThemeMode.light;
        case 'dark':
          _themeMode = ThemeMode.dark;
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
      case ThemeMode.dark:
        modeString = 'dark';
      case ThemeMode.system:
        modeString = 'system';
    }

    await _prefsService.setThemeMode(modeString);
  }

  ThemeMode get currentThemeMode => _themeMode;

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
            create: (context) =>
                getIt<CharactersBloc>()..add(const LoadCharacters()),
          ),
          BlocProvider(
            create: (context) =>
                getIt<FavoritesBloc>()..add(const LoadFavorites()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: _themeMode,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
