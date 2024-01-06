import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../film_manager/model/film.dart';
import '../../repositories/user_repository/models/user_data.dart';
import '../../repositories/user_repository/user_repository_base.dart';

part 'user_lists_event.dart';

part 'user_lists_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UserListState()) {
    on<LikeFilm>((event, emit) {
      _userLikes?.add(event.likedFilm);
      _userRepository
          .saveUserData(UserData(liked: _userLikes, toWatch: _userWatch));
      emit(FilmLiked(userLikes: _userLikes));
    });

    on<UnLikeFilm>((event, emit) {
      _userLikes.remove(event.unlikedFilm);
      _userRepository
          .updateUserData(UserData(liked: _userLikes, toWatch: _userWatch));
      emit(FilmUnLiked(userLikes: _userLikes));
    });

    on<AddToWatchFilm>((event, emit) {
      _userWatch.add(event.toWatch);
      _userRepository
          .saveUserData(UserData(liked: _userLikes, toWatch: _userWatch));
      emit(FilmAddedToWatch(userWatch: _userWatch));
    });

    on<RemoveFromWatchFilm>((event, emit) {
      _userWatch.remove(event.removedFromWatch);
      _userRepository
          .updateUserData(UserData(liked: _userLikes, toWatch: _userWatch));
      emit(FilmRemovedWatch(userWatch: _userWatch));
    });

    on<UserListsClearAll>((event, emit) {
      _userWatch.clear();
      _userLikes.clear();
      emit(ListsCleared());
    });

    on<UserListsSave>((event, emit) {
      _userRepository
          .saveUserData(UserData(liked: _userLikes, toWatch: _userWatch));
      emit(UserListsSaved());
    });

    on<GetUserLists>((event, emit) {
      _userLikes.addAll(event.userLikes);
      _userWatch.addAll(event.userWatch);
      emit(ListsObtained(
          userLikes: event.userLikes, userWatch: event.userWatch));
    });
  }

  final List<Film> _userLikes = [];
  final List<Film> _userWatch = [];
  final UserRepository _userRepository;

  List<Film> get likedFilms => _userLikes;
  List<Film> get filmsToWatch => _userWatch;
}
