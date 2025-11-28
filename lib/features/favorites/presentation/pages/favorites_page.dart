import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/core/presentation/widgets/empty_state_widget.dart';
import 'package:rick_and_morty/core/presentation/widgets/theme_toggle.dart';
import 'package:rick_and_morty/core/presentation/widgets/view_mode_toggle.dart';
import 'package:rick_and_morty/core/services/preferences_service.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late ViewMode _viewMode;

  @override
  void initState() {
    super.initState();

    final prefsService = context.read<PreferencesService>();
    final savedMode = prefsService.getViewMode();
    _viewMode = savedMode == 'list' ? ViewMode.list : ViewMode.grid;
  }

  void _onViewModeChanged(ViewMode mode) {
    setState(() {
      _viewMode = mode;
    });
    context.read<PreferencesService>().setViewMode(
          mode == ViewMode.grid ? 'grid' : 'list',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          const ThemeToggle(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ViewModeToggle(
              currentMode: _viewMode,
              onModeChanged: _onViewModeChanged,
            ),
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          final favoritesState = state as FavoritesLoaded;

          if (favoritesState.favorites.isEmpty) {
            return const EmptyStateWidget(
              message: 'No favorites yet\nAdd some characters to your favorites!',
              icon: CupertinoIcons.heart,
            );
          }

          return KeyedSubtree(
            key: ValueKey(
              'favorites_${favoritesState.favorites.length}_${favoritesState.favorites.map((f) => f.id).join('_')}',
            ),
            child: _buildFavoritesList(favoritesState.favorites),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList(List<CharacterEntity> favorites) {
    if (_viewMode == ViewMode.grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return _buildCharacterCard(favorites[index], index);
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return _buildCharacterCard(favorites[index], index);
        },
      );
    }
  }

  Widget _buildCharacterCard(CharacterEntity character, int index) {
    final favoriteCharacter = character.copyWith(isFavorite: true);

    return Dismissible(
      key: Key('favorite_${character.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      confirmDismiss: (direction) async {
        return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove from favorites?'),
            content: Text(
              'Are you sure you want to remove ${character.name} from your favorites?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        final removedCharacter = favoriteCharacter;
        context.read<CharactersBloc>().add(
              ToggleFavoriteCharacter(removedCharacter),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${character.name} removed from favorites'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<CharactersBloc>().add(
                      ToggleFavoriteCharacter(
                        removedCharacter.copyWith(isFavorite: false),
                      ),
                    );
              },
            ),
          ),
        );
      },
      child: CharacterCard(
        key: ValueKey('fav_card_${character.id}_${character.isFavorite}'),
        character: favoriteCharacter,
        viewMode: _viewMode,
        heroTagPrefix: 'favorites',
        onTap: () {
          context.push(
            '/character/${character.id}',
            extra: {
              'character': favoriteCharacter,
              'heroTag': 'favorites_${character.id}',
            },
          );
        },
        onFavoriteToggle: () {
          context.read<CharactersBloc>().add(
                ToggleFavoriteCharacter(favoriteCharacter),
              );
        },
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: (50 * (index % 6)).ms,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          delay: (50 * (index % 6)).ms,
        );
  }
}
