import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/domain/usecases/get_characters.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_state.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_state.dart';

@injectable
class CharactersBloc extends HydratedBloc<CharactersEvent, CharactersState> {
  CharactersBloc(
    this._getCharacters,
  ) : super(const CharactersInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<ToggleFavoriteCharacter>(_onToggleFavorite);
    on<RefreshCharacters>(_onRefreshCharacters);
    on<EnrichWithFavorites>(_onEnrichWithFavorites);
    on<SearchCharacters>(_onSearchCharacters);
    on<ClearSearch>(_onClearSearch);
  }

  final GetCharacters _getCharacters;

  FavoritesBloc? get _favoritesBloc {
    try {
      return GetIt.instance<FavoritesBloc>();
    } catch (e) {
      return null;
    }
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    if (!event.refresh && state is CharactersLoaded) {
      add(const EnrichWithFavorites());
      return;
    }

    emit(const CharactersLoading());
    final result = await _getCharacters(1);

    result.fold(
      (failure) => emit(CharactersError(failure.message)),
      (characters) {
        final enriched = _enrichWithFavorites(characters);

        emit(
          CharactersLoaded(
            characters: enriched,
            hasReachedMax: characters.length < 20,
            currentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharactersLoaded || currentState.hasReachedMax) {
      return;
    }

    emit(CharactersLoadingMore(currentState.characters));

    final nextPage = currentState.currentPage + 1;
    final result = await _getCharacters(nextPage);

    result.fold(
      (failure) => emit(
        currentState.copyWith(),
      ),
      (newCharacters) {
        final enrichedNew = _enrichWithFavorites(newCharacters);
        final hasReachedMax = newCharacters.length < 20;

        emit(
          CharactersLoaded(
            characters: currentState.characters + enrichedNew,
            hasReachedMax: hasReachedMax,
            currentPage: nextPage,
          ),
        );
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteCharacter event,
    Emitter<CharactersState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharactersLoaded) return;

    final updatedCharacters = currentState.characters.map((character) {
      if (character.id == event.character.id) {
        return character.copyWith(isFavorite: !character.isFavorite);
      }
      return character;
    }).toList();

    emit(
      currentState.copyWith(
        characters: updatedCharacters,
      ),
    );

    if (_favoritesBloc != null) {
      if (event.character.isFavorite) {
        _favoritesBloc!.add(RemoveFromFavorites(event.character.id));
      } else {
        final updatedChar = event.character.copyWith(isFavorite: true);
        _favoritesBloc!.add(AddToFavorites(updatedChar));
      }
    }
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    add(const LoadCharacters(refresh: true));
  }

  void _onEnrichWithFavorites(
    EnrichWithFavorites event,
    Emitter<CharactersState> emit,
  ) {
    final currentState = state;
    if (currentState is! CharactersLoaded) return;

    final enriched = _enrichWithFavorites(currentState.characters);
    emit(currentState.copyWith(characters: enriched));
  }

  List<CharacterEntity> _enrichWithFavorites(List<CharacterEntity> characters) {
    final favoritesState = _favoritesBloc?.state;
    if (favoritesState is! FavoritesLoaded) return characters;

    final favoriteIds = favoritesState.favorites.map((f) => f.id).toSet();

    return characters.map((char) {
      return char.copyWith(isFavorite: favoriteIds.contains(char.id));
    }).toList();
  }

  void _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharactersState> emit,
  ) {
    final currentState = state;
    if (currentState is! CharactersLoaded) return;

    emit(currentState.copyWith(searchQuery: event.query.toLowerCase()));
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<CharactersState> emit,
  ) {
    final currentState = state;
    if (currentState is! CharactersLoaded) return;

    emit(currentState.copyWith(searchQuery: ''));
  }

  @override
  CharactersState? fromJson(Map<String, dynamic> json) {
    try {
      return CharactersLoaded.fromJson(json);
    } catch (e) {
      return null; // Return null for invalid/old state
    }
  }

  @override
  Map<String, dynamic>? toJson(CharactersState state) {
    if (state is CharactersLoaded) {
      return state.toJson();
    }
    return null; // Only persist CharactersLoaded
  }
}
