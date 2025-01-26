import 'package:bingr/views/infopage/movie_info_page.dart';
import 'package:bingr/widgets/custom_dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MovieCardWidget extends StatelessWidget {

  final String posterUrl;
  final String movieName;
  final TextAlign align;
  final double fontSize;
  final String imdbId;

  const MovieCardWidget({
    Key? key,
    required this.posterUrl,
    required this.movieName,
    required this.align,
    required this.fontSize,
    required this.imdbId,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            child: TextButton(
              onPressed: () async {
                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop , child: MovieInfoPage(imdbId: imdbId , movieTitle: movieName)));
              },
              child: Image.network(
                posterUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.only(top: 10),
          child: Text(
            movieName,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins'
            ),
            maxLines: 2,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}