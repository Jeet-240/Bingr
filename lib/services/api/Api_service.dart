import 'dart:convert';
import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/classes/movie_info.dart';
import 'package:http/http.dart' as http;
import 'package:bingr/constants/urls.dart';

class ApiService {
  Future<List<MovieCard>> fetchMovieCards(
      {required String type, required int size}) async {
    final response = await http
        .get(Uri.parse("${MovieCardApi.apiUrl}/imdb/$type"), headers: {
      'x-rapidapi-key': 'f7b64b548amsh84e42db4cfcc959p1e1c36jsn810afa7363b1',
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movieList = (data as List)
          .map((movie) => MovieCard.fromJson(movie))
          .take(size)
          .toList();
      return movieList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<MovieInfo> fetchMovieInfo({required String imdbId}) async {
    final response = await http.get(
      Uri.parse('${MovieInfoApi.apiUrl}${MovieInfoApi.imdb}$imdbId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String , dynamic>;
      return MovieInfo.fromJson(data);
    } else {
      throw Exception('Failed to load movies');
    }
  }



}
