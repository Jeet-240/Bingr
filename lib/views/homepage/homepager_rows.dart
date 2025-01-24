import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:bingr/services/api/Api_service.dart';
import 'package:flutter/material.dart';

class HomepageRows extends StatelessWidget {
  final String type;
  const HomepageRows({
    required this.type,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ApiService apiService = ApiService();
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: apiService.fetchMovieCards(type: type, size: 12),
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
            return Center(child: Text("Error: ${snapshot.error}"));
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: screenWidth * 0.4,
                      child: MovieCardWidget(
                          posterUrl: movieList[index].posterUrl,
                          movieName: movieList[index].title,
                        align: TextAlign.center,
                      fontSize: 14,),
                    );
                  }),
            );
          }
        });
  }
}
