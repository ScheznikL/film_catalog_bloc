import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/film_manager/model/film_video.dart';
import 'package:film_catalog_bloc/film_manager/model/product_companies.dart';
import 'film.dart';
import 'genre_model.dart';
import 'credits.dart';

class FilmDetails extends Film {
  final List<GenreModel> genres;
  final List<ProductCompany> productCompanies;
  final int revenue;
  final int runtime;
  final Credits credits;
  final List<Film> similar;
  final int budget;
  final String? originalLanguage;
  final FilmVideo? filmVideo;
//<editor-fold desc="Data Methods">

  const FilmDetails({
    required super.id,
    required super.backdropPath,
    required this.genres,
    required super.overview,
    super.popularity,
    required super.posterPath,
    required this.productCompanies,
    required super.releaseDate,
    required this.revenue,
    required this.runtime,
    required super.title,
    required super.voteAverage,
    required super.voteCount,
    required this.credits,
    required this.similar,
    required super.adult,
    required this.budget,
    super.originalTitle,
    this.originalLanguage,
    this.filmVideo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is FilmDetails &&
          runtimeType == other.runtimeType &&
          genres == other.genres &&
          productCompanies == other.productCompanies &&
          revenue == other.revenue &&
          runtime == other.runtime &&
          credits == other.credits &&
          similar == other.similar &&
          budget == other.budget &&
          originalLanguage == other.originalLanguage &&
          filmVideo == other.filmVideo;

  @override
  int get hashCode =>
      super.hashCode ^
      genres.hashCode ^
      productCompanies.hashCode ^
      revenue.hashCode ^
      runtime.hashCode ^
      credits.hashCode ^
      similar.hashCode ^
      budget.hashCode ^
      originalLanguage.hashCode ^
      filmVideo.hashCode;

  const FilmDetails.empty()
      : genres = const [],
        productCompanies = const [],
        revenue = 0,
        runtime = 0,
        credits = const Credits.empty(),
        similar = const [],
        budget = 0,
        originalLanguage = '',
        filmVideo = const FilmVideo.empty(),
        super.empty();

// var ttt =  ProductCompany.fromJson(jsonData['production_companies'][0] as Map<String,dynamic>);
  FilmDetails.fromJson(
    Map<String, dynamic> json,
  )   : genres = List.of(json['genres']).map((entry) {
          //var ttt =  List.of(json['genres']);
          return GenreModel.fromJson(entry);
        }).toList(),
        productCompanies =
            List.of(json['production_companies'] ?? List.empty()).map((entry) {
          return ProductCompany.fromJson(entry);
        }).toList(),
        revenue = json['revenue'],
        runtime = json['runtime'],
        credits = Credits.fromJson(json['credits']),
        similar = List.from(json['similar']["results"])
            .map((js) => Film.fromJson(js))
            .toList(),
        budget = json['budget'],
        originalLanguage = json['original_language'],
        filmVideo = json['videos'] != null
            ? FilmVideo.fromJson(
                List.from(json['videos']["results"]).where((item) {
                return FilmVideo.fromJson(item).site == "YouTube" &&
                    FilmVideo.fromJson(item).type == "Trailer";
              }).firstOrNull)
            : FilmVideo.fromJson(json['film_video']),
        super.fromJson(json);

//  FilmDetails.videoFromJson():;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'genres': genres?.map((e) => e.toJson()).toList(),
      'production_companies': productCompanies,
      'revenue': revenue,
      'runtime': runtime,
      'credits': credits,
      'similar': {"results": similar.map((e) => e.toJson()).toList()},
      'budget': budget,
      'original_language': originalLanguage,
      'film_video': filmVideo,
    });
    return json;
  }
}
