part of 'user_lists_bloc.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object> get props => [];
}

class UserListsSave extends UserListEvent {
}

class GetUserLists extends UserListEvent {
  final List<Film> userLikes;
  final List<Film> userWatch;

  const GetUserLists({required this.userLikes,required this.userWatch});
}

class UserListsClearAll extends UserListEvent {
  const UserListsClearAll();
}


class LikeFilm extends UserListEvent {
  final Film likedFilm;

  const LikeFilm(this.likedFilm);

  @override
  List<Object> get props => [likedFilm];
}

class UnLikeFilm extends UserListEvent {
  final Film unlikedFilm;

  const UnLikeFilm(this.unlikedFilm);

  @override
  List<Object> get props => [unlikedFilm];
}

class AddToWatchFilm extends UserListEvent {
  final Film toWatch;

  const AddToWatchFilm(this.toWatch);

  @override
  List<Object> get props => [toWatch];
}

class RemoveFromWatchFilm extends UserListEvent {
  final Film removedFromWatch;

  const RemoveFromWatchFilm(this.removedFromWatch);

  @override
  List<Object> get props => [removedFromWatch];
}
