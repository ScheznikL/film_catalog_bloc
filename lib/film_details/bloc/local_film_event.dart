part of 'local_film_bloc.dart';

abstract class LocalFilmEvent {
  final String filmId;
  LocalFilmEvent(this.filmId);
}

class LoadDataEvent extends LocalFilmEvent {
  LoadDataEvent(super.filmId);
}

class CheckFilmExist extends LocalFilmEvent {
  CheckFilmExist(super.filmId);
}

class SaveDataEvent extends LocalFilmEvent {
  final FilmDetails film;

  SaveDataEvent(this.film) :
        super(film.id.toString());
}
