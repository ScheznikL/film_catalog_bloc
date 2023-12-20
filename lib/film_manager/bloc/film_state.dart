part of 'film_bloc.dart';


class FilmState extends Equatable{

  const FilmState({
    this.filmDetails = const FilmDetails.empty(),
    this.status = APIStatus.unknown,
    this.popularFilms = const [],
  });

/*  const FilmState.unknown() : this();

  const FilmState.error() : this(status: APIStatus.error);

  const FilmState.empty() : this(status: APIStatus.empty);

  const FilmState.loading(List<Film> popularFilms)
      : this(status: APIStatus.loading, popularFilms: popularFilms);

  const FilmState.loaded()
      : this(status: APIStatus.loaded);
*/
  final APIStatus status;
  final List<Film> popularFilms;
  final FilmDetails filmDetails;

  @override
  List<Object> get props => [status, popularFilms, filmDetails];

  FilmState copyWith({
    APIStatus? status,
    List<Film>? popularFilms,
    FilmDetails? filmDetails
  }) {
    return FilmState(
      popularFilms: popularFilms ?? this.popularFilms,
      status: status ?? this.status,
      filmDetails: filmDetails ?? this.filmDetails,
    );
  }

}

/*
final class FilmsError extends FilmState {
  final String errorMessage;

  const FilmsError(this.errorMessage);
}

final class FilmsSorted extends FilmState {
  final List<Film> sortedFilms;

  const FilmsSorted(this.sortedFilms);
}
*/