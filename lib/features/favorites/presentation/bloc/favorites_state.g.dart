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
      sortOrder: $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder']) ??
          SortOrder.ascending,
      sortField: $enumDecodeNullable(_$SortFieldEnumMap, json['sortField']) ??
          SortField.name,
    );

Map<String, dynamic> _$FavoritesLoadedToJson(FavoritesLoaded instance) =>
    <String, dynamic>{
      'favorites': instance.favorites.map((e) => e.toJson()).toList(),
      'sortOrder': _$SortOrderEnumMap[instance.sortOrder]!,
      'sortField': _$SortFieldEnumMap[instance.sortField]!,
    };

const _$SortOrderEnumMap = {
  SortOrder.ascending: 'ascending',
  SortOrder.descending: 'descending',
};

const _$SortFieldEnumMap = {
  SortField.name: 'name',
  SortField.status: 'status',
  SortField.species: 'species',
};
