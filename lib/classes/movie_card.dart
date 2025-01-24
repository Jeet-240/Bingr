import 'package:flutter/material.dart';

class MovieCard{
  late final String title;
  late final String posterUrl;

  MovieCard({required this.title, required this.posterUrl});

  factory MovieCard.fromJson(Map<String, dynamic> json ) {
    return MovieCard(
      title: json['primaryTitle'],
      posterUrl: json['primaryImage'],
    );
  }
}






