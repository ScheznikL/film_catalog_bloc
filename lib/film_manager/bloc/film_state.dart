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
    List<Film> tempList = List.of(this.popularFilms)..addAll(popularFilms?.where((element) => !this.popularFilms.contains(element)) ?? List.empty());
      return FilmState(
      popularFilms: tempList,
      status: status ?? this.status,
      filmDetails: filmDetails ?? this.filmDetails,
    );
  }

}