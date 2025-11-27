import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class FavoriteCharacters extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get species => text()();
  TextColumn get type => text()();
  TextColumn get gender => text()();
  TextColumn get image => text()();
  TextColumn get originName => text()();
  TextColumn get locationName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [FavoriteCharacters])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<FavoriteCharacter>> getAllFavorites() async {
    return select(favoriteCharacters).get();
  }

  Future<FavoriteCharacter?> getFavoriteById(int id) async {
    return (select(favoriteCharacters)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> addToFavorites(FavoriteCharactersCompanion character) async {
    await into(favoriteCharacters).insert(
      character,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> removeFromFavorites(int id) async {
    await (delete(favoriteCharacters)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> isFavorite(int id) async {
    final character = await getFavoriteById(id);
    return character != null;
  }

  Stream<List<FavoriteCharacter>> watchFavorites() {
    return select(favoriteCharacters).watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rick_and_morty.db'));
    return NativeDatabase(file);
  });
}
