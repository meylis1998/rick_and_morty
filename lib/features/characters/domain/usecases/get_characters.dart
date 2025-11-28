import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty/features/characters/domain/repositories/character_repository.dart';

@injectable
class GetCharacters {
  GetCharacters(this.repository);

  final CharacterRepository repository;

  Future<Either<Failure, List<CharacterEntity>>> call(int page) {
    return repository.getCharacters(page);
  }
}
