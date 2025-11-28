import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:rick_and_morty/features/characters/data/models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters(int page);
  Future<CharacterModel> getCharacterById(int id);
}

@Injectable(as: CharacterRemoteDataSource)
class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  CharacterRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<CharacterModel>> getCharacters(int page) async {
    try {
      final response = await _apiClient.getCharacters(page);
      return response.results;
    } catch (e) {
      throw ServerException('Failed to fetch characters: ${e.toString()}');
    }
  }

  @override
  Future<CharacterModel> getCharacterById(int id) async {
    try {
      return await _apiClient.getCharacterById(id);
    } catch (e) {
      throw ServerException('Failed to fetch character: ${e.toString()}');
    }
  }
}
