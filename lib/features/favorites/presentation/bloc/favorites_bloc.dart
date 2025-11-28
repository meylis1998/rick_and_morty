import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_state.dart';

@lazySingleton
class FavoritesBloc extends HydratedBloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesLoaded(favorites: [])) {
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  void _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state as FavoritesLoaded;

    final exists =
        currentState.favorites.any((c) => c.id == event.character.id);
    if (exists) return;

    final characterWithFavorite = event.character.copyWith(isFavorite: true);
    final updated = [...currentState.favorites, characterWithFavorite];

    emit(FavoritesLoaded(favorites: updated));
  }

  void _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state as FavoritesLoaded;

    final updated =
        currentState.favorites.where((c) => c.id != event.characterId).toList();

    emit(FavoritesLoaded(favorites: updated));
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) {
    try {
      return FavoritesLoaded.fromJson(json);
    } catch (e) {
      return const FavoritesLoaded(favorites: []);
    }
  }

  @override
  Map<String, dynamic>? toJson(FavoritesState state) {
    if (state is FavoritesLoaded) {
      return state.toJson();
    }
    return null;
  }
}
