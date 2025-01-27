
class MovieInfo {
  final String imdbId;
  late String title;
  late String year;
  late String boxOfficeCollection;
  late String plot;
  late String actors;
  late String posterURL;
  late List<Map<String , String>> ratings;
  late String imdbRating;
  late String duration;
  late String genre;
  late String director;
  late String awards;


  MovieInfo({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.actors,
    required this.boxOfficeCollection,
    required this.plot,
    required this.posterURL,
    required this.ratings,
    required this.imdbRating,
    required this.duration,
    required this.genre,
    required this.director,
    required this.awards,
  });

  factory MovieInfo.fromJson(Map<String , dynamic> json){
    return MovieInfo(
      imdbId: json['imdbID'].toString(),
      title: json['Title'].toString(),
      year: json['Year'].toString(),
      actors: (json['Actors'].toString()),
      boxOfficeCollection: json['BoxOffice'].toString() ,
      plot: json['Plot'].toString(),
      posterURL: json['Poster'].toString(),
      ratings: (json['Ratings'] as List<dynamic>)
        .map((rating) => {
          'Source' : rating['Source'].toString(),
          'Value' : rating['Value'].toString(),
      }).toList(),
      imdbRating: json['imdbRating'].toString() ,
      duration: json['Runtime'].toString(),
      genre: json['Genre'].toString(),
      director: json['Director'].toString(),
      awards: json['Awards']
    );
  }
}
