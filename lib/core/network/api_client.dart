import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:rick_and_morty/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty/features/characters/data/models/character_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://rickandmortyapi.com/api')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/character')
  Future<CharacterResponse> getCharacters(@Query('page') int page);

  @GET('/character/{id}')
  Future<CharacterModel> getCharacterById(@Path('id') int id);
}
