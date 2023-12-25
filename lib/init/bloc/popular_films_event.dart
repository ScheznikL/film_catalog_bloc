part of 'popular_films_bloc.dart';

@immutable
abstract class PopularFilmsEvent {}

final class FilmFetched extends PopularFilmsEvent {}
