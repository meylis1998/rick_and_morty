import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/features/characters/domain/usecases/get_characters.dart';
import 'package:rick_and_morty/features/characters/domain/usecases/toggle_favorite.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_state.dart';

@injectable
class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(
    this._getCharacters,
    this._toggleFavorite,
  ) : super(const CharactersInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<ToggleFavoriteCharacter>(_onToggleFavorite);
    on<RefreshCharacters>(_onRefreshCharacters);
  }

  final GetCharacters _getCharacters;
  final ToggleFavorite _toggleFavorite;

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    if (event.refresh && state is CharactersLoaded) {
      emit(CharactersLoading());
    } else if (state is! CharactersLoaded) {
      emit(CharactersLoading());
    }

    final result = await _getCharacters(1);

    result.fold(
      (failure) => emit(CharactersError(failure.message)),
      (characters) => emit(
        CharactersLoaded(
          characters: characters,
          hasReachedMax: characters.length < 20,
          currentPage: 1,
        ),
      ),
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
        final hasReachedMax = newCharacters.length < 20;
        emit(
          CharactersLoaded(
            characters: currentState.characters + newCharacters,
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

    final result = await _toggleFavorite(event.character);

    result.fold(
      (failure) {
        // Optionally show error
      },
      (_) {
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
      },
    );
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    add(const LoadCharacters(refresh: true));
  }
}
