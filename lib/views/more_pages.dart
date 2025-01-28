import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/constants/urls.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/api/Api_service.dart';

class MoreInfoPage extends StatelessWidget {
  const MoreInfoPage({super.key});

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
                'More Popular Movies',
                style: TextStyle(
                    color: Color.fromRGBO(250, 240, 230, 1),
                    fontWeight: FontWeight.w700),
              ),
            )),
        backgroundColor: backgroundColor,
        body: FutureBuilder<List<MovieCard>>(
          future: apiService.fetchMovieCards(
              type: MovieCardApi.popularMovies, size: 40),
          builder: (BuildContext context, snapshot) {
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
              final list = snapshot.data!;
              return GridView.builder(
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8, // Space between columns
                  mainAxisSpacing: 8, // Space between rows
                  childAspectRatio: 2 / 3, // Aspect ratio (width / height)
                ),
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: double.infinity, // Matches the grid item's width
                    height: 250, // Set a fixed height for the card
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  list[index].posterUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  list[index].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            }
          },
        ));
  }
}
