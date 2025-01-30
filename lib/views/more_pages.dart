import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/constants/urls.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api/Api_service.dart';

class MoreInfoPage extends StatefulWidget {
  final String category; // Declare the parameter

  const MoreInfoPage({super.key, required this.category});

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  final ScrollController _scrollController = ScrollController();
  List<MovieCard> displayedMovies = [];
  int _loadCount = 15;
  bool isLoad = false;
  ApiService apiService = ApiService(); // Initialize API service

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !isLoad) {
      _loadMoreMovies();
    }
  }

  Future<void> _fetchMovies() async {
    try {
      List<MovieCard> movies = await apiService.fetchMovieCards(
          type: widget.category, size: 40);
      setState(() {
        displayedMovies = movies.take(_loadCount).toList();
      });
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  void _loadMoreMovies() {
    if (isLoad || displayedMovies.length >= 40) return; // Prevent unnecessary calls

    setState(() => isLoad = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        int newCount = (_loadCount + 10).clamp(0, 40);
        _loadCount = newCount;
        _fetchMovies(); // Fetch again but keep previous movies
        isLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
            title: Text(
              widget.category,
              style: const TextStyle(
                  color: Color.fromRGBO(250, 240, 230, 1),
                  fontWeight: FontWeight.w700),
            )),
        backgroundColor: backgroundColor,
        body: displayedMovies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
          controller: _scrollController,
          itemCount: displayedMovies.length + (isLoad ? 1 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2 / 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index >= displayedMovies.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return MovieCardWidget(
              fontSize: 14,
              imdbId: displayedMovies[index].imdbID,
              align: TextAlign.center,
              movieName: displayedMovies[index].title,
              posterUrl: displayedMovies[index].posterUrl,
            );
          },
        ));
  }
}
