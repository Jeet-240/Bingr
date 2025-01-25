import 'package:bingr/classes/movie_info.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/services/api/Api_service.dart';
import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MovieInfoPage extends StatelessWidget {
  final String imdbId;
  const MovieInfoPage({Key? key, required this.imdbId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    ApiService apiService = ApiService();
    return Scaffold(
      appBar: AnimatedAppBar(actions: [], appBarColor: mainAppbarColor),
      backgroundColor: backgroundColor,
      body: FutureBuilder<MovieInfo>(
          future: apiService.fetchMovieInfo(imdbId: imdbId),
          builder: (context , snapshot){
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
            } else{
              final movieInfo = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10,  horizontal: 10),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          child: Image.network(
                            movieInfo.posterURL,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movieInfo.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: height*0.30,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Text(
                            'Plot:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),

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
