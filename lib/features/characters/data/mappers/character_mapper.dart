import 'package:drift/drift.dart';
import 'package:rick_and_morty/core/database/app_database.dart';
import 'package:rick_and_morty/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

extension CharacterModelMapper on CharacterModel {
  CharacterEntity toEntity({bool isFavorite = false}) {
    return CharacterEntity(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      originName: origin.name,
      locationName: location.name,
      image: image,
      isFavorite: isFavorite,
    );
  }
}

extension FavoriteCharacterMapper on FavoriteCharacter {
  CharacterEntity toEntity() {
    return CharacterEntity(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      originName: originName,
      locationName: locationName,
      image: image,
      isFavorite: true,
    );
  }
}

extension CharacterEntityMapper on CharacterEntity {
  FavoriteCharactersCompanion toFavoriteCompanion() {
    return FavoriteCharactersCompanion.insert(
      id: Value(id),
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      originName: originName,
      locationName: locationName,
      image: image,
    );
  }
}
