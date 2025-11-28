import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/domain/repositories/character_repository.dart';

@injectable
class GetFavorites {
  GetFavorites(this.repository);

  final CharacterRepository repository;

  Future<Either<Failure, List<CharacterEntity>>> call() {
    return repository.getFavorites();
  }

  Stream<List<CharacterEntity>> watch() {
    return repository.watchFavorites();
  }
}
