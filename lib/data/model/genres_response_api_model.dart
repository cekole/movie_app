import 'genre_api_model.dart';

class GenresResponseApiModel {
  final List<GenreApiModel> genres;

  const GenresResponseApiModel({required this.genres});

  factory GenresResponseApiModel.fromJson(Map<String, dynamic> json) {
    return GenresResponseApiModel(
      genres:
          (json['genres'] as List<dynamic>)
              .map((e) => GenreApiModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'genres': genres.map((e) => e.toJson()).toList()};
  }
}
