part of 'local_film_bloc.dart';

abstract class LocalFilmEvent {
  const LocalFilmEvent();
}

class LoadDataEvent extends LocalFilmEvent {
}

class CheckFilmExist extends LocalFilmEvent {
}

class SaveDataEvent extends LocalFilmEvent {

  final FilmDetails film;

  const SaveDataEvent(this.film);
}
