part of 'film_share_bloc.dart';

abstract class FilmShareState extends Equatable {
  const FilmShareState();
}
class InitialState extends FilmShareState {
  @override
  List<Object> get props => [];
}
class FilmShared extends FilmShareState {
  const FilmShared(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}