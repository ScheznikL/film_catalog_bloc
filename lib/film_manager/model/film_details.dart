import 'package:equatable/equatable.dart';
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
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilmDetails &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          backdropPath == other.backdropPath &&
          genres == other.genres &&
          overview == other.overview &&
          popularity == other.popularity &&
          posterPath == other.posterPath &&
          productCompanies == other.productCompanies &&
          releaseDate == other.releaseDate &&
          revenue == other.revenue &&
          runtime == other.runtime &&
          title == other.title &&
          voteAverage == other.voteAverage &&
          voteCount == other.voteCount &&
          credits == other.credits &&
          similar == other.similar &&
          adult == other.adult &&
          budget == other.budget &&
          originalTitle == other.originalTitle &&
          originalLanguage == other.originalLanguage);

  const FilmDetails.empty()
      : genres = const [],
        productCompanies = const [],
        revenue = 0,
        runtime = 0,
        credits = const Credits.empty(),
        similar = const [],
        budget = 0,
        originalLanguage = '',
        super.empty();

  FilmDetails copyWith({
    int? id,
    String? backdropPath,
    List<GenreModel>? genres,
    String? overview,
    double? popularity,
    String? posterPath,
    List<ProductCompany>? productCompanies,
    DateTime? releaseDate,
    int? revenue,
    int? runtime,
    String? title,
    double? voteAverage,
    int? voteCount,
    Credits? credits,
    List<Film>? similar,
    bool? adult,
    int? budget,
    String? originalTitle,
    String? originalLanguage,
  }) {
    return FilmDetails(
      id: id ?? this.id,
      backdropPath: backdropPath ?? this.backdropPath,
      genres: genres ?? this.genres,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      posterPath: posterPath ?? this.posterPath,
      productCompanies: productCompanies ?? this.productCompanies,
      releaseDate: releaseDate ?? this.releaseDate,
      revenue: revenue ?? this.revenue,
      runtime: runtime ?? this.runtime,
      title: title ?? this.title,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      credits: credits ?? this.credits,
      similar: similar ?? this.similar,
      adult: adult ?? this.adult,
      budget: budget ?? this.budget,
      originalTitle: originalTitle ?? this.originalTitle,
      originalLanguage: originalLanguage ?? this.originalLanguage,
    );
  }

// var ttt =  ProductCompany.fromJson(jsonData['production_companies'][0] as Map<String,dynamic>);
  FilmDetails.fromJson(Map<String, dynamic> json)
      : genres = List.of(json['genres']).map((entry) {
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
        super.fromJson(json);

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
    });
    return json;
  }
}
