import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../film_manager/model/film.dart';


part 'film_details_event.dart';

part 'film_details_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(const UserListState()) {
    on<LikeFilm>((event, emit) {
      _userLikes?.add(event.likedFilm);
      emit(FilmLiked(userLikes: _userLikes));
    });

    on<UnLikeFilm>((event, emit) {
      _userLikes.remove(event.unlikedFilm);
      emit(FilmUnLiked(userLikes: _userLikes));
    });

    on<AddToWatchFilm>((event, emit) {
      _userWatch.add(event.toWatch);
      emit(FilmAddedToWatch(userWatch: _userWatch));
    });

    on<RemoveFromWatchFilm>((event, emit) {
      _userWatch.remove(event.removedFormWatch);
      emit(FilmRemovedWatch(userWatch: _userWatch));
    });
  }

  final List<Film> _userLikes = [];
  final List<Film> _userWatch = [];

  List<Film> get likedFilms => _userLikes;
  List<Film> get filmsToWatch => _userWatch;
}
