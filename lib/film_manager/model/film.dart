import 'dart:convert';
import 'package:equatable/equatable.dart';

class Film extends Equatable {
  final int? id;
  final String? title;
  final String? originalTitle;
  final String? language;
  final double? popularity;
  final double? voteAverage;
  final int? voteCount;
  final String posterPath;
  final String backdropPath;
  final DateTime? releaseDate;
  final String? overview;
  final List<dynamic>? genreIds;
  final bool? adult;
  final bool? video;


  const Film({this.id,
    this.title,
    this.originalTitle,
    this.language,
    this.popularity,
    this.voteAverage,
    this.voteCount,
    String? posterPath,
    String? backdropPath,
    this.releaseDate,
    this.overview,
    this.genreIds,
    this.adult,
    this.video})
      : posterPath = posterPath ??
      "https://images.unsplash.com/photo-1536566482680-fca31930a0bd?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        backdropPath = backdropPath ??
            "https://images.unsplash.com/photo-1536566482680-fca31930a0bd?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

  Film.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        originalTitle = json['original_title'],
        language = json['original_language'],
        popularity = json['popularity'],
        voteAverage = double.parse(json['vote_average'].toStringAsFixed(1)),
        voteCount = json['vote_count'],
        posterPath = "http://image.tmdb.org/t/p/w500//${json['poster_path'] ?? ""}",
        backdropPath =
        "http://image.tmdb.org/t/p/w500//${json['backdrop_path']}",
        releaseDate = DateTime.parse(json['release_date']),
        overview = json['overview'],
        genreIds = json['genre_ids'] ?? List<int>.empty(),
        adult = json['adult'],
        video = json['video'];


  String postToJson(Film data) =>
      json.encode(data);

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "title": title,
        'original_title ': originalTitle,
        'original_language': language,
        'popularity': popularity,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'release_date': releaseDate.toString(),
        'overview': overview,
        'genre_ids': genreIds,
        'adult': adult,
        'video': video,
      };

  @override
  List<Object?> get props =>
      [
        id,
        title,
        originalTitle,
        language,
        popularity,
        voteAverage,
        voteCount,
        posterPath,
        backdropPath,
        releaseDate,
        overview,
        genreIds,
        adult,
        video
      ];

  const Film.empty(): id =1,
      title = "none",
      originalTitle ="none",
      language ='',
      popularity = 1,
      voteAverage = 0.0,
      voteCount = 0,
      posterPath = '',
      backdropPath = '',
      releaseDate = null,
      overview = '',
      genreIds = const [],
      adult = false,
      video = false;

}
