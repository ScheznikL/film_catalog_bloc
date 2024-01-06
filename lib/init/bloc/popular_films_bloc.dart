import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:film_catalog_bloc/film_manager/model/film.dart';
import '../../film_manager/bloc/film_bloc.dart';
import '../../repositories/api_repository/film_api.dart';

part 'popular_films_event.dart';
part 'popular_films_state.dart';

class PopularFilmsBloc extends Bloc<PopularFilmsEvent, PopularFilmsState> {
  PopularFilmsBloc({required this.filmsBloc}) : super(const PopularFilmsState()) {
    on<FilmFetched>(
        _onFilmFetched,
        );

  }
  final FilmBloc filmsBloc;
  StreamSubscription? filmSubscription;

  Future<void> _onFilmFetched(FilmFetched event, Emitter<PopularFilmsState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PopularFilmsStatus.initial) {
        return emit(state.copyWith(
          status: PopularFilmsStatus.success,
          films: filmsBloc.state.popularFilms,
          hasReachedMax: false,
        ));
      }
      filmsBloc.add(const FilmsStatusChanged(APIStatus.loadingPopularFilms));
      filmSubscription = filmsBloc.stream.listen((filmState) async {
          emit(filmState.popularFilms == null
                  ? state.copyWith(hasReachedMax: true)
                  : state.copyWith(
                    status: PopularFilmsStatus.success,
                    films: filmState.popularFilms,
                    hasReachedMax: false,)
          );

      });
      await filmSubscription?.asFuture();
    } catch (_) {
      emit(state.copyWith(status: PopularFilmsStatus.failure));
    }
  }

  @override
  Future<void> close() {
    filmSubscription?.cancel();
    return super.close();
  }
}
