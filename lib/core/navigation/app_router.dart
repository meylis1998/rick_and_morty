import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/core/navigation/bottom_nav_shell.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/presentation/pages/character_detail_page.dart';
import 'package:rick_and_morty/features/characters/presentation/pages/characters_page.dart';
import 'package:rick_and_morty/features/favorites/presentation/pages/favorites_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/characters',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/characters',
              builder: (context, state) => const CharactersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/character/:id',
      builder: (context, state) {
        final character = state.extra as CharacterEntity?;
        if (character == null) {
          return const Scaffold(
            body: Center(
              child: Text('Character not found'),
            ),
          );
        }
        return CharacterDetailPage(character: character);
      },
    ),
  ],
);
