import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../film_manager/model/film_details.dart';
import '../../film_manager/model/film.dart';
import '../../film_manager/model/product_companies.dart';

enum APIStatus { unknown, loadingPopularFilms,loadingFilmDetails, popularFilmsLoaded,filmDetailsLoaded, error, empty }
var apiKey = '15d2ea6d0dc1d476efbca3eba2b9bbfb';

class FilmAPIRepository {
  final _controller = StreamController<APIStatus>();
  late APIStatus _status;

  void dispose() => _controller.close();

  Stream<APIStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield APIStatus.unknown;
    yield* _controller.stream;
  }

   /*Future<String> fetchMovies(String film) async {
    // Make API request to TMDb

    var apiUrl = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$film');

    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;

      if (jsonData.containsKey('results')) {
        for (dynamic f in jsonData['results']) {
          if (f['adult'] == false && f.containsKey('poster_path')) {
            _searchResult = f['poster_path'] ?? "";

            _isLoading = false;
            return _searchResult;
          } else {
            _isLoading = false;
            continue;
          }
        }
      }
      return "";
    } else {
      _searchResult = 'Error fetching data';
      _isLoading = false;
      //print('Error fetching data');
      return "";
      //throw NetworkImageLoadException(statusCode: response.statusCode, uri: apiUrl)
    }
  }*/

   Future<List<Film>> getPopularMovies({int? page}) async {

    List<Film> films = [];
    // var apiUr = Uri.parse( 'https://api.themoviedb.org/3/movie/popular/movie?api_key=$apiKey&query=$film');
    var apiUrl = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&include_adult=false&"
            "include_video=false&page=$page&sort_by=popularity.desc");
    try {
      var response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as Map<String, dynamic>;

        if (jsonData.containsKey('results')) {
          for (dynamic f in jsonData['results']) {
            if (f.containsKey('poster_path')) {
              films.add(Film.fromJson(f));
            } else {
              continue;
            }
          }
          return films;
        }
        _controller.add(APIStatus.empty);
        return List.empty();
      } else {
        _controller.add(APIStatus.error);
        return List.empty();
      }
    } catch (ex) {
      _controller.add(APIStatus.error);
      return List.empty();
    }
  }

  Future<FilmDetails?> getFilmDetails(int filmId) async {
    var apiUrl = Uri.parse(
        "https://api.themoviedb.org/3/movie/$filmId?api_key=$apiKey&append_to_response=videos,credits,similar");
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as Map<String, dynamic>;

        return FilmDetails.fromJson(jsonData);
      } else {
        _controller.add(APIStatus.error);
        return null;
      }
    } catch (e) {
      _controller.add(APIStatus.error);
      return null;
    }
  }

}
