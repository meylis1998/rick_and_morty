import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharactersEvent {
  const LoadCharacters({this.refresh = false});

  final bool refresh;

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreCharacters extends CharactersEvent {
  const LoadMoreCharacters();
}

class ToggleFavoriteCharacter extends CharactersEvent {
  const ToggleFavoriteCharacter(this.character);

  final CharacterEntity character;

  @override
  List<Object?> get props => [character];
}

class RefreshCharacters extends CharactersEvent {
  const RefreshCharacters();
}
