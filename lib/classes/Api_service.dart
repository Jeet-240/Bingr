import 'dart:convert';
import 'package:bingr/classes/movie_card.dart';
import 'package:http/http.dart' as http;
import 'package:bingr/constants/urls.dart';

class ApiService {
  Future<List<MovieCard>> fetchMovieCards() async{
    final response = await http.get(
      Uri.parse("${MovieCardApi.apiUrl}/imdb/india/top-rated-indian-movies"),
      headers: {
        'x-rapidapi-key': MovieCardApi.apiKey,
        'x-rapidapi-host':'imdb236.p.rapidapi.com',
      }
    );
    print(response.statusCode);
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      return (data as List).map((movie) => MovieCard.fromJson(movie)).toList();
    }else{
      throw Exception('Failed to load movies');
    }
  }

}