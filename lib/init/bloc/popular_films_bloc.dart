import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:film_catalog_bloc/film_manager/model/film.dart';
import '../../film_manager/bloc/film_bloc.dart';
import '../../repositories/api_repository/film_api.dart';
import '../../util/transformer.dart';

part 'popular_films_event.dart';
part 'popular_films_state.dart';

//todo combine
class PopularFilmsBloc extends Bloc<PopularFilmsEvent, PopularFilmsState> {
  PopularFilmsBloc({required this.filmsBloc}) : super(const PopularFilmsState()) {
    on<FilmFetched>(
        _onFilmFetched,
        //transformer: throttleDroppable(throttleDuration)
        );

  }
  final FilmBloc filmsBloc;
  //final FilmAPIRepository filmAPIRepository;
  StreamSubscription? filmSubscription;

  int _page = 2;
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
     // final popularFilms = await _tryGetPopularFilms(page:_page++);
      filmSubscription = filmsBloc.stream.listen((filmState) async {

       // if (filmState.status == APIStatus.popularFilmsLoaded)
        {
          emit(filmState.popularFilms == null
                  ? state.copyWith(hasReachedMax: true)
                  : state.copyWith(
                    status: PopularFilmsStatus.success,
                    films: filmState.popularFilms,
                    hasReachedMax: false,)
          );
        }
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
  /*Future<List<Film>?> _tryGetPopularFilms({required int? page}) async {
    try {
      final popularFilms = await filmAPIRepository.getPopularMovies(page: page);
      return popularFilms;
    } catch (_) {
      return null;
    }
  }*/
}
