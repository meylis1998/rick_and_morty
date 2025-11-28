// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesLoaded _$FavoritesLoadedFromJson(Map<String, dynamic> json) =>
    FavoritesLoaded(
      favorites: (json['favorites'] as List<dynamic>)
          .map((e) => CharacterEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavoritesLoadedToJson(FavoritesLoaded instance) =>
    <String, dynamic>{
      'favorites': instance.favorites.map((e) => e.toJson()).toList(),
    };
