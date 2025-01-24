import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:bingr/classes/Api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



returnMovieCards() async{

}


class MyCarouselSlider extends StatelessWidget {
  const MyCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    ApiService apiService = ApiService();
    return FutureBuilder<List<MovieCard>>(future: apiService.fetchMovieCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: dialogBoxColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No movies available"));
          }else{
            final movies = snapshot.data;
            return CarouselSlider(options: CarouselOptions(
              height: 400,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              autoPlayCurve: Curves.easeInOut,
              enableInfiniteScroll: true,
              aspectRatio: 16/9,
            ),
              items: movies?.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return MovieCardWidget(posterUrl: movie.posterUrl, movieName: movie.title);
                },
              );
            }).toList(),
            );
          }
        }
    );
  }
}
