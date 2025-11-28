import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characters/data/datasources/character_local_datasource.dart';
import 'package:rick_and_morty/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:rick_and_morty/features/characters/data/mappers/character_mapper.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/domain/repositories/character_repository.dart';

@Injectable(as: CharacterRepository)
class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  final CharacterRemoteDataSource _remoteDataSource;
  final CharacterLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<CharacterEntity>>> getCharacters(
    int page,
  ) async {
    try {
      final characters = await _remoteDataSource.getCharacters(page);

      // Check favorite status for each character
      final entities = <CharacterEntity>[];
      for (final character in characters) {
        final isFav = await _localDataSource.isFavorite(character.id);
        entities.add(character.toEntity(isFavorite: isFav));
      }

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> getFavorites() async {
    try {
      final favorites = await _localDataSource.getFavorites();
      return Right(favorites.map((f) => f.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Stream<List<CharacterEntity>> watchFavorites() {
    return _localDataSource.watchFavorites().map(
          (favorites) => favorites.map((f) => f.toEntity()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(
    CharacterEntity character,
  ) async {
    try {
      final isFav = await _localDataSource.isFavorite(character.id);

      if (isFav) {
        await _localDataSource.removeFromFavorites(character.id);
      } else {
        await _localDataSource.addToFavorites(character.toFavoriteCompanion());
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<bool> isFavorite(int id) async {
    return _localDataSource.isFavorite(id);
  }
}
