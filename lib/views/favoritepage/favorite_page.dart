import 'package:bingr/services/api/Api_service.dart';
import 'package:bingr/services/auth/auth_service.dart';
import 'package:bingr/widgets/favorite_movie_card.dart';
import 'package:flutter/material.dart';
import 'package:bingr/services/database/firebase_database_service.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/colors.dart';
import '../infopage/movie_info_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ApiService apiService = ApiService();
  FirebaseDatabaseProvide firebaseDatabaseProvide = FirebaseDatabaseProvide();
  final String _uid = AuthService.firebase().currentUser!.uid;
  late Future<List<Map<String, dynamic>>> list;
  List<Map<String, dynamic>> deleteList = [];
  List<Map<String, dynamic>> localList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = _fetchList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _commitDeletes();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchList() async {
    final list = await firebaseDatabaseProvide.fetchWishlist(uid: _uid);

    setState(() {
      localList = List.from(list ?? []);
    });
    return localList;
  }

  void removeFromList(Map<String, dynamic> movie, int index) {
    final itemToDelete = movie;

    setState(() {
      localList.remove(itemToDelete);
      deleteList.add(itemToDelete);
    });


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item Deleted. Tap to Undo.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                localList.add(itemToDelete);
                deleteList.remove(itemToDelete);
              });
            }),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _commitDeletes() async {
    for (var item in deleteList) {
      await firebaseDatabaseProvide.removeFromWishList(
          uid: _uid, imdbId: item['imdbId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = AuthService.firebase().currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mainAppbarColor,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Favorites',
                style: TextStyle(
                    color: Color.fromRGBO(250, 240, 230, 1),
                    fontWeight: FontWeight.w700),
              ),
            ),
          )),
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: _fetchList,
        child: FutureBuilder(
            future: list,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: dialogBoxColor,
                  ),
                );
              } else if (snapshot.hasError && snapshot.data != null) {
                return SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Error: ${snapshot.error}"),
                      ElevatedButton(
                        onPressed: () {
                          _fetchList();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data!.isEmpty ||
                  snapshot.data == null ||
                  localList.isEmpty) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 400,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty_box.png',
                            height: 175, width: 175),
                        SizedBox(height: 10),
                        Text(
                          'No Movies Added in the list!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                var movies = localList.reversed.toList();
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: localList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var info = movies[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: favoriteMovieCardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 120,
                                child: FavoriteMovieCardWidget(
                                  posterUrl: info['posterUrl'],
                                  movieName: info['title'],
                                  imdbId: info['imdbId'],
                                  onPressed: () async {
                                    final shouldRefresh = await Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: MovieInfoPage(
                                            imdbId: info['imdbId'],
                                            movieTitle: info['title']),
                                      ),
                                    );
                                    // If the wishlist was updated, refresh the list
                                    if (shouldRefresh == false) {
                                      setState(() {
                                        list = _fetchList(); // Refresh the list
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  border: Border(
                                left: BorderSide(color: Colors.white, width: 2),
                              )),
                              child: TextButton(
                                onPressed: () {
                                  removeFromList(info, index);
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
