import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:rick_and_morty/features/characters/data/mappers/character_mapper.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/domain/repositories/character_repository.dart';

@Injectable(as: CharacterRepository)
class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(
    this._remoteDataSource,
  );

  final CharacterRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<CharacterEntity>>> getCharacters(
    int page,
  ) async {
    try {
      final characters = await _remoteDataSource.getCharacters(page);

      final entities = characters.map((c) => c.toEntity()).toList();

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
