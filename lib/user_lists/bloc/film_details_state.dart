part of 'film_details_bloc.dart';

class UserListState extends Equatable {
  final List<Film>? userLikes;
  final List<Film>? userWatch;

  const UserListState({this.userLikes, this.userWatch});

  @override
  List<Object?> get props => [userLikes, userWatch];
}


class FilmLiked extends UserListState {
  final List<Film> userLikes;

  const FilmLiked({required this.userLikes}) : super(userLikes: userLikes);

  @override
  List<Object> get props => [userLikes];
}

class FilmUnLiked extends UserListState {
  final List<Film> userLikes;

  const FilmUnLiked({required this.userLikes}) : super(userLikes: userLikes);

  @override
  List<Object> get props => [userLikes];
}

class FilmAddedToWatch extends UserListState {
  final List<Film> userWatch;

  const FilmAddedToWatch({required this.userWatch})
      : super(userWatch: userWatch);

  @override
  List<Object> get props => [userWatch];
}

class FilmRemovedWatch extends UserListState {
  final List<Film> userWatch;

  const FilmRemovedWatch({required this.userWatch})
      : super(userWatch: userWatch);

  @override
  List<Object> get props => [userWatch];
}
