import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/film_manager/model/film_details.dart';

import '../../repositories/api_repository/film_api.dart';
import '../model/film.dart';

part 'film_event.dart';
part 'film_state.dart';

class FilmBloc extends Bloc<FilmEvent, FilmState> {
  FilmBloc({required FilmAPIRepository filmAPIRepository})
      : _filmAPIRepository = filmAPIRepository,
        super(FilmState(status: APIStatus.unknown)) {
    on<FilmsStatusChanged>(_onFilmsStatusChanged);
  }
  @override
  Future<void> close() {
    _filmApiStatusSubscription.cancel();
    return super.close();
  }

  final FilmAPIRepository _filmAPIRepository;
  late StreamSubscription<APIStatus> _filmApiStatusSubscription;

  int _page = 0;

  Future<void> _onFilmsStatusChanged(
    FilmsStatusChanged event,
    Emitter<FilmState> emit,
  ) async {
    switch (event.status) {
      case APIStatus.empty:
        return emit(state.copyWith(status: APIStatus.empty));
      case APIStatus.error:
        return emit(state.copyWith(status: APIStatus.error));
      case APIStatus.popularFilmsLoaded:
        return emit(state.copyWith(status: APIStatus.popularFilmsLoaded));
      case APIStatus.loadingPopularFilms:
        ++_page;
        final popularFilms = await _tryGetPopularFilms(page: _page);
        return emit(
          popularFilms != null
              ? state.copyWith(
                  popularFilms: popularFilms,
                  status: APIStatus.popularFilmsLoaded)
              : state.copyWith(status: APIStatus.unknown, popularFilms: []),
        );
      case APIStatus.unknown:
        state.copyWith(status: APIStatus.unknown);
      case APIStatus.loadingFilmDetails:
        final film = await _tryGetFilmDetails(id: event.id);
        return emit(
          film != null
              ? state.copyWith(
                  filmDetails: film, status: APIStatus.filmDetailsLoaded)
              : state.copyWith(
                  status: APIStatus.unknown, filmDetails: FilmDetails.empty()),
        );
      case APIStatus.filmDetailsLoaded:
        return emit(state.copyWith(status: APIStatus.filmDetailsLoaded));
    }
  }

  Future<List<Film>?> _tryGetPopularFilms({required int? page}) async {
    try {
      final popularFilms =
          await _filmAPIRepository.getPopularMovies(page: page);
      return popularFilms;
    } catch (_) {
      return null;
    }
  }

  Future<FilmDetails?> _tryGetFilmDetails({required int? id}) async {
    try {
      final film = await _filmAPIRepository.getFilmDetails(id!);
      return film;
    } catch (_) {
      return null;
    }
  }
}
