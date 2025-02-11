import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bingr/services/api/Api_service.dart';
import 'package:flutter/material.dart';
import 'package:bingr/constants/urls.dart';

const carouselSize = 8;

class MyCarouselSlider extends StatefulWidget {
  const MyCarouselSlider({super.key});

  @override
  State<MyCarouselSlider> createState() => _MyCarouselSliderState();
}

class _MyCarouselSliderState extends State<MyCarouselSlider> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<MovieCard>> _futureMovies;
  late ApiService apiService = ApiService();

  @override
  void initState(){
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies(){
    setState(() {
      _futureMovies = apiService.fetchMovieCards(type: MovieCardApi.topRatedIndianMovies, size: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<MovieCard>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 400,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: dialogBoxColor,
              ),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchMovies,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No movies available"));
          } else {
            final movies = snapshot.data;
            return CarouselSlider(
              options: CarouselOptions(
                height: 400,
                autoPlay: true,
                viewportFraction: 0.7,
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: true,
                aspectRatio: 16/9,
              ),
              items: movies?.map((movie) {
                return Builder(
                  builder: (BuildContext context) {
                    return MovieCardWidget(
                        posterUrl: movie.posterUrl, movieName: movie.title, align: TextAlign.center , fontSize: 18, imdbId: movie.imdbID,);
                  },
                );
              }).toList(),
            );
          }
        });
  }
}
