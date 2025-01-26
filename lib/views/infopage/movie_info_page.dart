import 'package:bingr/classes/movie_info.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/services/api/Api_service.dart';
import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:bingr/constants/colors.dart';

import '../../constants/urls.dart';

class MovieInfoPage extends StatelessWidget {
  final String imdbId;
  final String movieTitle;
  const MovieInfoPage(
      {Key? key, required this.imdbId, required this.movieTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    ApiService apiService = ApiService();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
          title: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              movieTitle,
              style: TextStyle(
                color: Color.fromRGBO(250, 240, 230, 1),
                fontWeight: FontWeight.w700
              ),
            ),
          )),
      backgroundColor: backgroundColor,
      body: FutureBuilder<MovieInfo>(
          future: apiService.fetchMovieInfo(imdbId: imdbId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: height,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: dialogBoxColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No movies available"));
            } else {
              final movieInfo = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: SizedBox(
                        height: 400,
                        child: Image.network(
                          movieInfo.posterURL.replaceAll('SX300', 'SX1000'),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '${movieInfo.title} (${movieInfo.year})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 35.0,
                              ),
                              Text(
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 14,
                                  ),
                                  '${movieInfo.ratings[0]['Value']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${movieInfo.duration} | ",
                                style: TextStyle(
                                  color: Color.fromRGBO(140, 171, 255, 1),
                                  fontSize: 12,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  movieInfo.genre,
                                  style: TextStyle(
                                      color: Color.fromRGBO(140, 171, 255, 1),
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieInfo.ratings.length,
                        itemBuilder: (BuildContext context , int index){
                          return Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 243, 239, 1.0),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            child: Row(
                              spacing: 10,
                              children: [
                                Text(
                                  movieInfo.ratings[index]['Source']!,
                                  style: TextStyle(
                                    color: Color.fromRGBO(81, 43, 129, 1),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  movieInfo.ratings[index]['Value']!,
                                  style: TextStyle(
                                    color: Color.fromRGBO(81, 43, 129, 1),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: dialogBoxColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plot:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: 0.5),
                          ),
                          Text(
                            movieInfo.plot,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
