import 'package:bingr/widgets/custom_dialogbox.dart';
import 'package:flutter/material.dart';

class MovieCardWidget extends StatelessWidget {

  final String posterUrl;
  final String movieName;

  const MovieCardWidget({
    Key? key,
    required this.posterUrl,
    required this.movieName,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
              ),
              onPressed: () async {
                  await showErrorDialog(context, 'Button Tapped!');
              },
              child: Image.network(
                posterUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          movieName,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins'
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}