
class MovieInfo {
  final String imdbId;
  late String title;
  late String year;
  late String boxOfficeCollection;
  late String plot;
  late List<String>actors;
  late String posterURL;
  late List<Map<String , String>> ratings;
  late String imdbRating;


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

  });

  factory MovieInfo.fromJson(Map<String , dynamic> json){
    return MovieInfo(
      imdbId: json['imdbID'] as String,
      title: json['Title']  as String,
      year: json['Year']  as String,
      actors: (json['Actors'] as String).split(',').map((e) => e.trim()).toList(),
      boxOfficeCollection: json['BoxOffice'] as String ?? 'N/A',
      plot: json['Plot']  as String,
      posterURL: json['Poster']  as String,
      ratings: (json['Ratings'] as List<dynamic>)
        .map((rating) => {
          'Source' : rating['Source'] as String,
          'Value' : rating['Value'] as String,
      }).toList(),
      imdbRating: json['imdbRating']  as String ,
    );
  }
}
