import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

enum SortOrder { ascending, descending }

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({
    required this.favorites,
    this.sortOrder = SortOrder.ascending,
  });

  final List<CharacterEntity> favorites;
  final SortOrder sortOrder;

  FavoritesLoaded copyWith({
    List<CharacterEntity>? favorites,
    SortOrder? sortOrder,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [favorites, sortOrder];
}

class FavoritesError extends FavoritesState {
  const FavoritesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
