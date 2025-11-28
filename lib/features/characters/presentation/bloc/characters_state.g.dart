// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharactersLoaded _$CharactersLoadedFromJson(Map<String, dynamic> json) =>
    CharactersLoaded(
      characters: (json['characters'] as List<dynamic>)
          .map((e) => CharacterEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasReachedMax: json['hasReachedMax'] as bool,
      currentPage: (json['currentPage'] as num).toInt(),
      searchQuery: json['searchQuery'] as String? ?? '',
    );

Map<String, dynamic> _$CharactersLoadedToJson(CharactersLoaded instance) =>
    <String, dynamic>{
      'characters': instance.characters.map((e) => e.toJson()).toList(),
      'hasReachedMax': instance.hasReachedMax,
      'currentPage': instance.currentPage,
      'searchQuery': instance.searchQuery,
    };
