import 'package:bingr/classes/movie_info.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/constants/urls.dart';
import 'package:bingr/services/api/Api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/error.dart';

class MovieInfoPage extends StatefulWidget {
  final String imdbId;
  final String movieTitle;
  const MovieInfoPage(
      {Key? key, required this.imdbId, required this.movieTitle})
      : super(key: key);

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {

  ApiService apiService = ApiService();
  late Future<MovieInfo> _movieInfo;

  @override
  void initState() {
    super.initState();
    _fetchMovieInfo();
  }

  void _fetchMovieInfo(){
    setState(() {
      _movieInfo = apiService.fetchMovieInfo(imdbId: widget.imdbId);
    });
  }


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
              widget.movieTitle,
              style: TextStyle(
                  color: Color.fromRGBO(250, 240, 230, 1),
                  fontWeight: FontWeight.w700),
            ),
          )),
      backgroundColor: backgroundColor,
      body: FutureBuilder<MovieInfo>(
          future: _movieInfo,
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
              return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RetryWidget(),
                ElevatedButton(
                  onPressed: _fetchMovieInfo,
                  child: const Text("Retry"),
                ),
              ],
                            );
            } else if (!snapshot.hasData) {
              return Center(child: Text("No movies available"));
            } else {
              final movieInfo = snapshot.data!;
              final Uri _url = Uri.parse('${imdbUrl}${widget.imdbId}/');
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
                          fit: BoxFit.contain,
                          width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              );
                            }, errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                          );
                        }
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
                            spacing: 5,
                            children: [
                              Image(
                                image: AssetImage('assets/images/imdb.png'),
                                fit: BoxFit.contain,
                                height: 35,
                                width: 35,
                              ),
                              Text(
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 13,
                                  ),
                                  '${movieInfo.imdbRating}/10'),
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
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(250, 243, 239, 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            alignment: Alignment.center,
                            child: Row(
                              spacing: 15,
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
                      height: 50,
                     margin: EdgeInsets.only(top: 15),
                     decoration: BoxDecoration(
                        color: Colors.yellow.shade700,
                       borderRadius: BorderRadius.circular(5)
                      ) ,
                      child: TextButton
                        ( onPressed: ()async{_launchUrl(_url);},
                          child: Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.tv, color: Colors.black, size: 40,),
                              Text(
                                  'Watch Trailer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                      ),
                    )



                    ,
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Plot:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.5),
                          ),
                          Text(
                            movieInfo.plot,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        moreInfo(context, 'Director', movieInfo.director),
                        moreInfo(context, 'Actor', movieInfo.actors),
                        moreInfo(context, 'Awards', movieInfo.awards),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Box Office: ${movieInfo.boxOfficeCollection}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(181, 84, 0, 1)
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  ConstrainedBox moreInfo(BuildContext context, String title, String info) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 80,
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: movieDetailsColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color.fromRGBO(250, 240, 230, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              info,
              style: TextStyle(
                color: Color.fromRGBO(68, 199, 206, 1.0),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}


Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}