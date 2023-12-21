part of 'film_bloc.dart';


class FilmState extends Equatable{

  const FilmState({
    this.filmDetails = const FilmDetails.empty(),
    this.status = APIStatus.unknown,
    this.popularFilms = const [],
  });

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