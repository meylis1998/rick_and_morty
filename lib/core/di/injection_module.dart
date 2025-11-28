import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rick_and_morty/core/database/app_database.dart';
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:rick_and_morty/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  DioClient get dioClient => DioClient();

  @lazySingleton
  Dio get dio => dioClient.dio;

  @lazySingleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
