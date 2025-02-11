import 'package:bingr/views/infopage/movie_info_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FavoriteMovieCardWidget extends StatelessWidget {
  final String posterUrl;
  final String movieName;
  final String imdbId;

  const FavoriteMovieCardWidget({
    Key? key,
    required this.posterUrl,
    required this.movieName,
    required this.imdbId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black12, // Adjust background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: MovieInfoPage(imdbId: imdbId, movieTitle: movieName),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                height: 120,  // Increased height
                width: 80,   // Adjusted width
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress, color: Colors.white),
                    ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12), // Spacing between image & text
            // Movie Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    movieName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
