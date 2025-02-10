import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:bingr/services/api/Api_service.dart';
import 'package:flutter/material.dart';

class HomepageRows extends StatefulWidget {
  final String type;
  const HomepageRows({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<HomepageRows> createState() => _HomepageRowsState();
}

class _HomepageRowsState extends State<HomepageRows> {
  ApiService apiService = ApiService();
  late Future<List<MovieCard>> _futureMovieCards;

  @override
  void initState(){
    super.initState();
    _fetchMovieCards();
  }

  void _fetchMovieCards(){
    setState(() {
      _futureMovieCards = apiService.fetchMovieCards(type: widget.type, size: 12);
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: _futureMovieCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: dialogBoxColor,
              ),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 250 ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  ElevatedButton(
                    onPressed: _fetchMovieCards,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No movies available"));
          } else {
            final movies = snapshot.data!;
            final movieList = movies.toList();
            return SizedBox(
              height: 250,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movieList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: screenWidth * 0.4,
                      child: MovieCardWidget(
                          posterUrl: movieList[index].posterUrl,
                          movieName: movieList[index].title,
                        align: TextAlign.center,
                      fontSize: 14,
                      imdbId: movieList[index].imdbID,),
                    );
                  }),
            );
          }
        });
  }
}
