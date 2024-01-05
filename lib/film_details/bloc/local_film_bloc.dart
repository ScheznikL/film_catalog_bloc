import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/film_manager/model/film_details.dart';
import 'package:path_provider/path_provider.dart';

part 'local_film_event.dart';
part 'local_film_state.dart';

class LocalFilmBloc extends Bloc<LocalFilmEvent, LocalFilmState> {
  LocalFilmBloc() : super(InitialState()) {
    on<LoadDataEvent>(_onLoadDataEvent);
    on<CheckFilmExist>(_onCheckFilmExist);
    on<SaveDataEvent>(_onSaveDataEvent);
  }

  Future<void> _onSaveDataEvent(SaveDataEvent event,
      Emitter<LocalFilmState> emit) async {
    try {
      _saveDataToFile(event.film.toJson(), filmId: event.film.id ?? 0);
      emit(FilmSavedState(filmDetails: event.film));
    } catch (ex) {
      emit(LoadSaveErrorState(ex.toString()));
    }
  }

  Future<void> _onCheckFilmExist(CheckFilmExist event,
      Emitter<LocalFilmState> emit) async {
    final file = await _getLocalFile(event.filmId);
    var existFilm = await file.exists();
    if (existFilm == true) {
      emit(const FileExistState(exist: true));
    } else {
      emit(const FileExistState(exist: false));
    }
  }

  Future<void> _onLoadDataEvent(LoadDataEvent event,
      Emitter<LocalFilmState> emit) async {
    try {
      final file = await _getLocalFile(event.filmId);
      String? fileContent = await file.readAsString();
      Map<String, dynamic>? json = jsonDecode(fileContent) as Map<String, dynamic>;
      emit(fileContent.isNotEmpty
          ? FilmLoadedState(filmDetails: FilmDetails.fromJson(json))
          : const FilmLoadedState(filmDetails: (FilmDetails.empty())));
    } catch (ex) {
      emit(LoadSaveErrorState(ex.toString()));
    }
  }

 /* @override
  void onTransition(Transition<LocalFilmEvent, LocalFilmState> transition) {
    //
    super.onTransition(transition);
    print(transition);
  }*/

  Future<void> _saveDataToFile(Map<String, dynamic> jsonData,
      {required int filmId}) async {
    final file = await _getLocalFile(filmId.toString());
    await file.writeAsString(jsonEncode(jsonData));
  }

  Future<File> _getLocalFile(String filmId) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/film_details_$filmId.json');
  }

}

