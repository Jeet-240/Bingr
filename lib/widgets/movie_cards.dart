import 'package:bingr/widgets/custom_dialogbox.dart';
import 'package:flutter/material.dart';

class MovieCardWidget extends StatelessWidget {

  final String posterUrl;
  final String movieName;
  final TextAlign align;
  final double fontSize;

  const MovieCardWidget({
    Key? key,
    required this.posterUrl,
    required this.movieName,
    required this.align,
    required this.fontSize,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () async {
                  await showErrorDialog(context, 'Button Tapped!');
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