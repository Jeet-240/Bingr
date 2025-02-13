
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoriteMovieCardWidget extends StatelessWidget {
  final String posterUrl;
  final String movieName;
  final String imdbId;
  final VoidCallback onPressed;

  const FavoriteMovieCardWidget({
    Key? key,
    required this.posterUrl,
    required this.movieName,
    required this.imdbId,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                height: 130,  // Increased height
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
