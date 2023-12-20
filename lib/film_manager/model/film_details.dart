import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/film_manager/model/product_companies.dart';
import 'film.dart';
import 'genre_model.dart';
import 'credits.dart';

class FilmDetails extends Film {
// final int id;
  // final String backdropPath;
  final List<GenreModel> genres;
/*  final String overview;
  final double? popularity;
  final String posterPath;*/
  final List<ProductCompany> productCompanies;
  // final DateTime releaseDate;
  final int revenue;
  final int runtime;
  /* final String title;
  final double voteAverage;
  final int voteCount;*/

  // final String? trailerVideo;
  final Credits credits;
  final List<Film> similar;

  // final bool adult;
  final int budget;
  // final String? originalTitle;
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


  const FilmDetails.empty():
      genres = const [],
      productCompanies = const  [],
      revenue = 0,
      runtime =0 ,
      credits = const Credits.empty(),
      similar = const [],
      budget = 0,
      originalLanguage ='',
      super.empty();


  /*
  @override
  int get hashCode =>
      id.hashCode ^
      backdropPath.hashCode ^
      genres.hashCode ^
      overview.hashCode ^
      popularity.hashCode ^
      posterPath.hashCode ^
      productCompanies.hashCode ^
      releaseDate.hashCode ^
      revenue.hashCode ^
      runtime.hashCode ^
      title.hashCode ^
      voteAverage.hashCode ^
      voteCount.hashCode ^
      credits.hashCode ^
      similar.hashCode ^
      adult.hashCode ^
      budget.hashCode ^
      originalTitle.hashCode ^
      originalLanguage.hashCode;
*/

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

  FilmDetails.fromJson(Map<String, dynamic> json):
      genres= List<GenreModel>.from(json['genres']),
      productCompanies= List<ProductCompany>.from(json['production_companies']),
      revenue= json['revenue'],
      runtime= json['runtime'],
      credits= json['credits'].getCredits(),
      similar= json['similar'].getSimilar(),
      budget= json['budget'],
      originalLanguage= json['original_language'],
      super.fromJson(json);

}


extension GetProperList on Map {
  List<Film> getSimilar() {
    List<Film> similar = [];
    if (containsKey('results')) {
      for (dynamic f in this['results']) {
        if (f != null) {
          similar.add(Film.fromJson(f));
        } else {
          continue;
        }
      }
    }
    return similar;
  }
}

extension GetProperListOfCredits on Map {
  Credits getCredits() {
    if (containsKey('cast') && containsKey('crew')) {
      String director = List.from(this['crew']).firstWhere((x) =>  x['job'] == 'Director')['name'] ??  'N/A';
      String coDirector = List.from(this['crew']).firstWhere((x) =>  x['job'] == 'Co-Director')['name'] ??  'N/A';
      return Credits(
          cast: this['cast'],
          director: director,
          coDirector: coDirector);
    }
    return const Credits.empty();
  }

  static String getDirectorName(List rawData) {
    return rawData.firstWhere(
          (e) => e['job'] == 'Director',
          orElse: () => {'name': null},
        )['name'] ??
        'N/A';
  }

  static String getWriterName(List rawData) {
    return rawData.firstWhere(
          (e) => e['job'] == 'Writer',
          orElse: () => {'name': null},
        )['name'] ??
        'N/A';
  }

  static String getProducerName(List rawData) {
    return rawData.firstWhere(
          (e) => e['job'] == 'Producer' || e['job'] == 'Executive Producer',
          orElse: () => {'name': null},
        )['name'] ??
        'N/A';
  }
}
