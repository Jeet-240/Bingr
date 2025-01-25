
class MovieCard{
  late final String title;
  late final String posterUrl;
  late final String imdbID;

  MovieCard({required this.title, required this.posterUrl , required this.imdbID});

  factory MovieCard.fromJson(Map<String, dynamic> json ) {
    return MovieCard(
      title: json['primaryTitle'],
      posterUrl: json['primaryImage'],
      imdbID : json['id'],
    );
  }
}






