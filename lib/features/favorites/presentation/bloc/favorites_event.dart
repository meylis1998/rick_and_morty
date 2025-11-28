import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddToFavorites extends FavoritesEvent {
  const AddToFavorites(this.character);

  final CharacterEntity character;

  @override
  List<Object?> get props => [character];
}

class RemoveFromFavorites extends FavoritesEvent {
  const RemoveFromFavorites(this.characterId);

  final int characterId;

  @override
  List<Object?> get props => [characterId];
}
