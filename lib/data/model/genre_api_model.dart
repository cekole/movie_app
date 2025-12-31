import '../../domain/models/models.dart';

class GenreApiModel {
  final int id;
  final String name;

  const GenreApiModel({required this.id, required this.name});

  factory GenreApiModel.fromJson(Map<String, dynamic> json) {
    return GenreApiModel(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  /// Convert to domain model
  Genre toDomain() {
    return Genre(id: id, name: name);
  }

  /// Create from domain model
  factory GenreApiModel.fromDomain(Genre genre) {
    return GenreApiModel(id: genre.id, name: genre.name);
  }
}
