import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/film_manager/model/film_details.dart';

part 'local_film_event.dart';
part 'local_film_state.dart';

class LocalFilmBloc extends Bloc<LocalFilmEvent, LocalFilmState> {
  LocalFilmBloc() : super(InitialState()) {
    on<LoadDataEvent>(_onLoadDataEvent);
    on<CheckFilmExist>(_onCheckFilmExist);
    on<SaveDataEvent>(_onSaveDataEvent); //todo
  }

  Future<void> _onSaveDataEvent(
      SaveDataEvent event, Emitter<LocalFilmState> emit) async {
    try {
      saveDataToFile(event.film.toJson());
      emit(FilmSavedState(filmDetails: event.film));
    } catch (_) {
      emit(const LoadSaveErrorState());
    }
  }

  Future<void> _onCheckFilmExist(
      CheckFilmExist event, Emitter<LocalFilmState> emit) async {
    final file = File(
        'D:/StudioProjects/film_catalog_bloc/lib/local_storage/film_details.json');

    /*
    var existFilm = await Future.wait<bool>([
      file.exists(),
      () async {
        int length = await file.length();
        return length > 0;
      }()
    ]);
    existFilm.every((element) => true)
    */
    var existFilm = await file.exists();
    if (existFilm == true) {
      emit(const FileExistState(exist: true));
    } else {
      emit(const FileExistState(exist: false));
    }
  }

  Future<void> _onLoadDataEvent(
      LoadDataEvent event, Emitter<LocalFilmState> emit) async {
    final file = File(
        'D:/StudioProjects/film_catalog_bloc/lib/local_storage/film_details.json');
    try {
      String? fileContent = await file.readAsString();
      Map<String, dynamic>? json = jsonDecode(fileContent);
      emit(json != null && fileContent.isNotEmpty
          ? FilmLoadedState(filmDetails: FilmDetails.fromJson(json))
          : const FilmLoadedState(filmDetails: (FilmDetails.empty())));
    } catch (_) {
      emit(const LoadSaveErrorState());
    }
  }

  @override
  void onTransition(Transition<LocalFilmEvent, LocalFilmState> transition) {
    //todo debag clean
    super.onTransition(transition);
    print(transition);
  }

  ///todo

  Future<void> saveDataToFile(Map<String, dynamic> jsonData) async {
    final file = File(
        'D:/StudioProjects/film_catalog_bloc/lib/local_storage/film_details.json');
    await file.writeAsString(jsonEncode(jsonData));
  }
}
