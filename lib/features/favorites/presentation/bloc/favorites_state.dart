import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character_entity.dart';

part 'favorites_state.g.dart';

enum SortOrder { ascending, descending }

enum SortField { name, status, species }

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

@JsonSerializable(explicitToJson: true)
class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({
    required this.favorites,
    this.sortOrder = SortOrder.ascending,
    this.sortField = SortField.name,
  });

  final List<CharacterEntity> favorites;
  final SortOrder sortOrder;
  final SortField sortField;

  FavoritesLoaded copyWith({
    List<CharacterEntity>? favorites,
    SortOrder? sortOrder,
    SortField? sortField,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      sortOrder: sortOrder ?? this.sortOrder,
      sortField: sortField ?? this.sortField,
    );
  }

  factory FavoritesLoaded.fromJson(Map<String, dynamic> json) =>
      _$FavoritesLoadedFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesLoadedToJson(this);

  @override
  List<Object?> get props => [favorites, sortOrder, sortField];
}

class FavoritesError extends FavoritesState {
  const FavoritesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
