part of 'film_share_bloc.dart';

abstract class FilmShareEvent {}

class ShareFilm extends FilmShareEvent{
  final String title;
  final String videoUrl;
  ShareFilm({required this.title, required this.videoUrl});
}
