import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/core/presentation/widgets/empty_state_widget.dart';
import 'package:rick_and_morty/core/presentation/widgets/error_widget.dart';
import 'package:rick_and_morty/core/presentation/widgets/theme_toggle.dart';
import 'package:rick_and_morty/core/presentation/widgets/view_mode_toggle.dart';
import 'package:rick_and_morty/core/services/preferences_service.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_event.dart';
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
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<SortField>(
                      icon: const Icon(Icons.filter_list),
                      tooltip: 'Sort by',
                      onSelected: (SortField field) {
                        context
                            .read<FavoritesBloc>()
                            .add(ChangeSortField(field));
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: SortField.name,
                          child: Row(
                            children: [
                              Icon(
                                state.sortField == SortField.name
                                    ? Icons.check
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text('Name'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: SortField.status,
                          child: Row(
                            children: [
                              Icon(
                                state.sortField == SortField.status
                                    ? Icons.check
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text('Status'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: SortField.species,
                          child: Row(
                            children: [
                              Icon(
                                state.sortField == SortField.species
                                    ? Icons.check
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text('Species'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        state.sortOrder == SortOrder.ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      tooltip: state.sortOrder == SortOrder.ascending
                          ? 'Ascending'
                          : 'Descending',
                      onPressed: () {
                        context
                            .read<FavoritesBloc>()
                            .add(const ToggleSortOrder());
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<FavoritesBloc>().add(const LoadFavorites());
              },
            );
          }

          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const EmptyStateWidget(
                message:
                    'No favorites yet\nAdd some characters to your favorites!',
                icon: Icons.favorite_border,
              );
            }

            return _buildFavoritesList(state.favorites);
          }

          return const SizedBox.shrink();
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
        return await showDialog<bool>(
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
        final removedCharacter = character;
        context.read<FavoritesBloc>().add(
              RemoveFromFavorites(character.id),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${character.name} removed from favorites'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<FavoritesBloc>().add(
                      AddToFavorites(removedCharacter),
                    );
              },
            ),
          ),
        );
      },
      child: CharacterCard(
        character: character,
        viewMode: _viewMode,
        onTap: () {
          context.push('/character/${character.id}', extra: character);
        },
        onFavoriteToggle: () {
          context.read<FavoritesBloc>().add(
                RemoveFromFavorites(character.id),
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
