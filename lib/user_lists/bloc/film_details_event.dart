part of 'film_details_bloc.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object> get props => [];
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
  final Film removedFormWatch;

  const RemoveFromWatchFilm(this.removedFormWatch);

  @override
  List<Object> get props => [removedFormWatch];
}
