import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/database/app_database.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';

abstract class CharacterLocalDataSource {
  Future<List<FavoriteCharacter>> getFavorites();
  Stream<List<FavoriteCharacter>> watchFavorites();
  Future<void> addToFavorites(FavoriteCharactersCompanion character);
  Future<void> removeFromFavorites(int id);
  Future<bool> isFavorite(int id);
}

@Injectable(as: CharacterLocalDataSource)
class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  CharacterLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<FavoriteCharacter>> getFavorites() async {
    try {
      return await _database.getAllFavorites();
    } catch (e) {
      throw CacheException('Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Stream<List<FavoriteCharacter>> watchFavorites() {
    return _database.watchFavorites();
  }

  @override
  Future<void> addToFavorites(FavoriteCharactersCompanion character) async {
    try {
      await _database.addToFavorites(character);
    } catch (e) {
      throw CacheException('Failed to add favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromFavorites(int id) async {
    try {
      await _database.removeFromFavorites(id);
    } catch (e) {
      throw CacheException('Failed to remove favorite: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(int id) async {
    try {
      return await _database.isFavorite(id);
    } catch (e) {
      throw CacheException('Failed to check favorite status: ${e.toString()}');
    }
  }
}
