import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<CharacterEntity>>> getCharacters(int page);
  Future<Either<Failure, List<CharacterEntity>>> getFavorites();
  Stream<List<CharacterEntity>> watchFavorites();
  Future<Either<Failure, void>> toggleFavorite(CharacterEntity character);
  Future<bool> isFavorite(int id);
}
