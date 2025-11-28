// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:rick_and_morty/core/di/injection_module.dart' as _i15;
import 'package:rick_and_morty/core/network/api_client.dart' as _i242;
import 'package:rick_and_morty/core/network/dio_client.dart' as _i850;
import 'package:rick_and_morty/core/services/preferences_service.dart' as _i44;
import 'package:rick_and_morty/core/theme/theme_cubit.dart' as _i819;
import 'package:rick_and_morty/features/characters/data/datasources/character_remote_datasource.dart'
    as _i170;
import 'package:rick_and_morty/features/characters/data/repositories/character_repository_impl.dart'
    as _i256;
import 'package:rick_and_morty/features/characters/domain/repositories/character_repository.dart'
    as _i952;
import 'package:rick_and_morty/features/characters/domain/usecases/get_characters.dart'
    as _i817;
import 'package:rick_and_morty/features/characters/presentation/bloc/characters_bloc.dart'
    as _i314;
import 'package:rick_and_morty/features/favorites/presentation/bloc/favorites_bloc.dart'
    as _i319;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => injectionModule.prefs,
      preResolve: true,
    );
    gh.factory<_i819.ThemeCubit>(() => _i819.ThemeCubit());
    gh.lazySingleton<_i850.DioClient>(() => injectionModule.dioClient);
    gh.lazySingleton<_i361.Dio>(() => injectionModule.dio);
    gh.lazySingleton<_i319.FavoritesBloc>(() => _i319.FavoritesBloc());
    gh.singleton<_i44.PreferencesService>(
      () => _i44.PreferencesService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i242.ApiClient>(
      () => injectionModule.apiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i170.CharacterRemoteDataSource>(
      () => _i170.CharacterRemoteDataSourceImpl(gh<_i242.ApiClient>()),
    );
    gh.factory<_i952.CharacterRepository>(
      () =>
          _i256.CharacterRepositoryImpl(gh<_i170.CharacterRemoteDataSource>()),
    );
    gh.factory<_i817.GetCharacters>(
      () => _i817.GetCharacters(gh<_i952.CharacterRepository>()),
    );
    gh.factory<_i314.CharactersBloc>(
      () => _i314.CharactersBloc(gh<_i817.GetCharacters>()),
    );
    return this;
  }
}

class _$InjectionModule extends _i15.InjectionModule {}
