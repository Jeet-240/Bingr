import 'package:bingr/classes/movie_card.dart';
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
    final data =  apiService.fetchMovieCards();
    return FutureBuilder<List<MovieCard>>(future: apiService.fetchMovieCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
            ),
              items: movies?.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            movie.posterUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              );
            }).toList(),
            );
          }
        }
    );
  }
}
