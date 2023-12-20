part of 'film_bloc.dart';

abstract class FilmEvent {
  const FilmEvent();
}

//final class FetchFilms extends FilmEvent {}

final class _FetchNextPage extends FilmEvent {}

final class _FetchPopularFilms extends FilmEvent {
  const _FetchPopularFilms({required this.page});

  final int? page;
}
/*
final class SortFilms extends FilmEvent {
  final SortCriterion criterion;

  const SortFilms(this.criterion);
}*/
final class FilmsStatusChanged extends FilmEvent {//**
  const FilmsStatusChanged(this.status): page = 0, id = 0;
  const FilmsStatusChanged.withPage(this.status, this.page): id = 0;
  const FilmsStatusChanged.withId(this.status, this.id): page = 1;

  final APIStatus status;
  final int? page;
  final int? id;
}

