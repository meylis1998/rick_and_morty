import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

part 'characters_state.g.dart';

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

@JsonSerializable(explicitToJson: true)
class CharactersLoaded extends CharactersState {
  const CharactersLoaded({
    required this.characters,
    required this.hasReachedMax,
    required this.currentPage,
    this.searchQuery = '',
  });

  final List<CharacterEntity> characters;
  final bool hasReachedMax;
  final int currentPage;
  final String searchQuery;

  CharactersLoaded copyWith({
    List<CharacterEntity>? characters,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  factory CharactersLoaded.fromJson(Map<String, dynamic> json) =>
      _$CharactersLoadedFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersLoadedToJson(this);

  @override
  List<Object?> get props => [characters, hasReachedMax, currentPage, searchQuery];
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
