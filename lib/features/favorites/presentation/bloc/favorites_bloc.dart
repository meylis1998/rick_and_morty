import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/features/characters/domain/usecases/toggle_favorite.dart';
import 'package:rick_and_morty/features/favorites/domain/usecases/get_favorites.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(
    this._getFavorites,
    this._toggleFavorite,
  ) : super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<WatchFavorites>(_onWatchFavorites);
    on<ToggleSortOrder>(_onToggleSortOrder);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    final result = await _getFavorites.call();

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) {
        final sortedFavorites = _sortFavorites(favorites, SortOrder.ascending);
        emit(
          FavoritesLoaded(
            favorites: sortedFavorites,
            sortOrder: SortOrder.ascending,
          ),
        );
      },
    );
  }

  Future<void> _onWatchFavorites(
    WatchFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    await emit.forEach(
      _getFavorites.watch(),
      onData: (favorites) {
        final currentState = state;
        final sortOrder = currentState is FavoritesLoaded
            ? currentState.sortOrder
            : SortOrder.ascending;

        final sortedFavorites = _sortFavorites(favorites, sortOrder);

        return FavoritesLoaded(
          favorites: sortedFavorites,
          sortOrder: sortOrder,
        );
      },
      onError: (error, stackTrace) {
        return FavoritesError(error.toString());
      },
    );
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
      newSortOrder,
    );

    emit(
      currentState.copyWith(
        favorites: sortedFavorites,
        sortOrder: newSortOrder,
      ),
    );
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    final character = currentState.favorites.firstWhere(
      (c) => c.id == event.characterId,
    );

    await _toggleFavorite(character);
  }

  List<T> _sortFavorites<T extends dynamic>(
    List<T> favorites,
    SortOrder sortOrder,
  ) {
    final sorted = List<T>.from(favorites);
    sorted.sort((a, b) {
      final aName = (a as dynamic).name as String;
      final bName = (b as dynamic).name as String;

      return sortOrder == SortOrder.ascending
          ? aName.compareTo(bName)
          : bName.compareTo(aName);
    });
    return sorted;
  }
}
