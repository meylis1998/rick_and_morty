import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class WatchFavorites extends FavoritesEvent {
  const WatchFavorites();
}

class ToggleSortOrder extends FavoritesEvent {
  const ToggleSortOrder();
}

class RemoveFromFavorites extends FavoritesEvent {
  const RemoveFromFavorites(this.characterId);

  final int characterId;

  @override
  List<Object?> get props => [characterId];
}
