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
      'x-rapidapi-key': '617a560e91mshb48ac88667ea1a2p140fd5jsnb70a0db30506',
      'x-rapidapi-host': 'imdb236.p.rapidapi.com',
    });
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
      Uri.parse('${OmdbApi.apiUrl}${OmdbApi.imdb}$imdbId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String , dynamic>;
      return MovieInfo.fromJson(data);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieCard>> searchMovie({required String searchQuery}) async {
    final response = await http.get(
      Uri.parse("${OmdbApi.apiUrl}${OmdbApi.search}$searchQuery"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["Search"] != null) {
        List movies = data["Search"]; // Extract the list of movies
        return movies.map((movie) {
          return MovieCard(
            title: movie["Title"] ?? "Unknown Title",
            posterUrl: movie["Poster"] ?? "",
            imdbID: movie["imdbID"] ?? "",
          );
        }).toList();
      } else {
        throw Exception("No movies found");
      }
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

}
