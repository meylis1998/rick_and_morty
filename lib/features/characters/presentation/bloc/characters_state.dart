import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

abstract class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object?> get props => [];
}

class CharactersInitial extends CharactersState {
  const CharactersInitial();
}

class CharactersLoading extends CharactersState {
  const CharactersLoading();
}

class CharactersLoaded extends CharactersState {
  const CharactersLoaded({
    required this.characters,
    required this.hasReachedMax,
    required this.currentPage,
  });

  final List<CharacterEntity> characters;
  final bool hasReachedMax;
  final int currentPage;

  CharactersLoaded copyWith({
    List<CharacterEntity>? characters,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [characters, hasReachedMax, currentPage];
}

class CharactersError extends CharactersState {
  const CharactersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CharactersLoadingMore extends CharactersState {
  const CharactersLoadingMore(this.characters);

  final List<CharacterEntity> characters;

  @override
  List<Object?> get props => [characters];
}
