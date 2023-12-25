part of 'local_film_bloc.dart';

abstract class LocalFilmState extends Equatable {
  const LocalFilmState();
}

class InitialState extends LocalFilmState {
  @override
  List<Object> get props => [];
}

class FileExistState extends LocalFilmState {
  final bool exist;
  const FileExistState({required this.exist});
  @override
  List<Object?> get props => [];
}

class FilmEmptyState extends LocalFilmState {
  const FilmEmptyState();

  @override
  List<Object?> get props => [];
}

class FilmLoadedState extends LocalFilmState {
  final FilmDetails? filmDetails;
  const FilmLoadedState({required this.filmDetails});
  @override
  List<Object?> get props => [filmDetails];
}

class FilmSavedState extends LocalFilmState {
  final FilmDetails? filmDetails;
  const FilmSavedState({required this.filmDetails});
  @override
  List<Object?> get props => [filmDetails];
}

class LoadSaveErrorState extends LocalFilmState {

  final String message;

  @override
  List<Object?> get props =>[];

  const LoadSaveErrorState(this.message);
}