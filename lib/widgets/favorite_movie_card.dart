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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ClipRRect(
            child: TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: MovieInfoPage(
                            imdbId: imdbId, movieTitle: movieName)));
              },
              child: CachedNetworkImage(
                imageUrl: posterUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: Colors.grey),
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.only(top: 5),
          child: Text(
            movieName,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins'),
            maxLines: 2,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
