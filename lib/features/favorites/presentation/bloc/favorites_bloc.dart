import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_state.dart';

@injectable
class FavoritesBloc extends HydratedBloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<ToggleSortOrder>(_onToggleSortOrder);
    on<ChangeSortField>(_onChangeSortField);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  void _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state;

    if (currentState is FavoritesLoaded) {
      return;
    }

    emit(const FavoritesLoaded(
      favorites: [],
      sortOrder: SortOrder.ascending,
    ));
  }

  void _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state;

    if (currentState is! FavoritesLoaded) {
      emit(FavoritesLoaded(
        favorites: [event.character],
        sortOrder: SortOrder.ascending,
      ));
      return;
    }

    final exists =
        currentState.favorites.any((c) => c.id == event.character.id);
    if (exists) return;

    final updated = [...currentState.favorites, event.character];
    final sorted = _sortFavorites(
      updated,
      currentState.sortField,
      currentState.sortOrder,
    );

    emit(currentState.copyWith(favorites: sorted));
  }

  void _onToggleSortOrder(
    ToggleSortOrder event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    final newSortOrder = currentState.sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;

    final sortedFavorites = _sortFavorites(
      currentState.favorites,
      currentState.sortField,
      newSortOrder,
    );

    emit(
      currentState.copyWith(
        favorites: sortedFavorites,
        sortOrder: newSortOrder,
      ),
    );
  }

  void _onChangeSortField(
    ChangeSortField event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    final sortedFavorites = _sortFavorites(
      currentState.favorites,
      event.sortField,
      currentState.sortOrder,
    );

    emit(
      currentState.copyWith(
        favorites: sortedFavorites,
        sortField: event.sortField,
      ),
    );
  }

  void _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    final updated =
        currentState.favorites.where((c) => c.id != event.characterId).toList();

    emit(currentState.copyWith(favorites: updated));
  }

  List<CharacterEntity> _sortFavorites(
    List<CharacterEntity> favorites,
    SortField sortField,
    SortOrder sortOrder,
  ) {
    final sorted = List<CharacterEntity>.from(favorites);
    sorted.sort((a, b) {
      int comparison;

      switch (sortField) {
        case SortField.name:
          comparison = a.name.compareTo(b.name);
        case SortField.status:
          comparison = a.status.compareTo(b.status);
        case SortField.species:
          comparison = a.species.compareTo(b.species);
      }

      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });
    return sorted;
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) {
    try {
      return FavoritesLoaded.fromJson(json);
    } catch (e) {
      return null;
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
