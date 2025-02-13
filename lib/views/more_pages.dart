import 'package:bingr/classes/movie_card.dart';
import 'package:bingr/constants/urls.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api/Api_service.dart';

class MorePage extends StatefulWidget {
  final String category; // Declare the parameter

  const MorePage({super.key, required this.category});

  @override
  State<MorePage> createState() => _MorePage();
}

class _MorePage extends State<MorePage> {
  final ScrollController _scrollController = ScrollController();
  List<MovieCard> displayedMovies = [];
  int _loadCount = 15;
  bool isLoad = false;
  ApiService apiService = ApiService();
  MovieCardApi movieCardApi = MovieCardApi();
  late String _title;


  void setTitle(){
    if(widget.category == 'most-popular-tv'){
      _title = 'Popular TV Shows';
    }else{
      _title = 'Popular Movies';
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(_onScroll);
    setTitle();
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
          type: widget.category, size: 100);
      setState(() {
        displayedMovies = movies.take(_loadCount).toList();
      });
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  void _loadMoreMovies() {
    if (isLoad || displayedMovies.length >= 100) return; // Prevent unnecessary calls

    setState(() => isLoad = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        int newCount = (_loadCount + 10).clamp(0, 100);
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
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
            title: Text(
              _title,
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
