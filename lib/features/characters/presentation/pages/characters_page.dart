import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/core/presentation/widgets/empty_state_widget.dart';
import 'package:rick_and_morty/core/presentation/widgets/error_widget.dart';
import 'package:rick_and_morty/core/presentation/widgets/view_mode_toggle.dart';
import 'package:rick_and_morty/core/services/preferences_service.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_state.dart';
import 'package:rick_and_morty/features/characters/presentation/widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();
  late ViewMode _viewMode;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    final prefsService = context.read<PreferencesService>();
    final savedMode = prefsService.getViewMode();
    _viewMode = savedMode == 'list' ? ViewMode.list : ViewMode.grid;

    context.read<CharactersBloc>().add(const LoadCharacters());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharactersBloc>().add(const LoadMoreCharacters());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
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
        title: const Text('Characters'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ViewModeToggle(
              currentMode: _viewMode,
              onModeChanged: _onViewModeChanged,
            ),
          ),
        ],
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state is CharactersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CharactersError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<CharactersBloc>().add(const LoadCharacters());
              },
            );
          }

          if (state is CharactersLoaded) {
            if (state.characters.isEmpty) {
              return const EmptyStateWidget(
                message: 'No characters found',
                icon: Icons.person_off_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CharactersBloc>().add(const RefreshCharacters());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: _buildCharactersList(state),
            );
          }

          if (state is CharactersLoadingMore) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CharactersBloc>().add(const RefreshCharacters());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: _buildCharactersListWithLoader(state.characters),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCharactersList(CharactersLoaded state) {
    if (_viewMode == ViewMode.grid) {
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: state.characters.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _buildCharacterCard(state.characters[index]);
        },
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: state.characters.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _buildCharacterCard(state.characters[index]);
        },
      );
    }
  }

  Widget _buildCharactersListWithLoader(List<CharacterEntity> characters) {
    if (_viewMode == ViewMode.grid) {
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: characters.length + 1,
        itemBuilder: (context, index) {
          if (index >= characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _buildCharacterCard(characters[index]);
        },
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: characters.length + 1,
        itemBuilder: (context, index) {
          if (index >= characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _buildCharacterCard(characters[index]);
        },
      );
    }
  }

  Widget _buildCharacterCard(CharacterEntity character) {
    return CharacterCard(
      character: character,
      viewMode: _viewMode,
      onTap: () {
        context.push('/character/${character.id}', extra: character);
      },
      onFavoriteToggle: () {
        context.read<CharactersBloc>().add(
              ToggleFavoriteCharacter(character),
            );
      },
    );
  }
}
