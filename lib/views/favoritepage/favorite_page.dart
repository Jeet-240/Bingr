import 'package:bingr/services/api/Api_service.dart';
import 'package:bingr/services/auth/auth_service.dart';
import 'package:bingr/widgets/favorite_movie_card.dart';
import 'package:flutter/material.dart';
import 'package:bingr/services/database/firebase_database_service.dart';

import '../../constants/colors.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('disposed');
  }

  void _fetchList()async {
    setState(() {
      list = firebaseDatabaseProvide.fetchWishlist(uid: _uid).then((data) => data ?? []);
    });
  }

  void removeFromList(String imdbId)async{
    await firebaseDatabaseProvide.removeFromWishList(uid: _uid, imdbId: imdbId);
    setState(() {
      list = firebaseDatabaseProvide.fetchWishlist(uid: _uid).then((data) => data ?? []);
    });
  }


  @override
  Widget build(BuildContext context) {
    FirebaseDatabaseProvide firebaseDatabaseProvide = FirebaseDatabaseProvide();
    final uid = AuthService.firebase().currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
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
      body: FutureBuilder(
          future: list,
          builder: (context , snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 300,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: dialogBoxColor,
                ),
              );
            } else if (snapshot.hasError && snapshot.data !=null) {
              return SizedBox(
                height: 250 ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Error: ${snapshot.error}"),
                    ElevatedButton(
                      onPressed: (){
                        _fetchList();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data == null) {
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
                      Image.asset(
                          'assets/images/empty_box.png',
                          height: 175,
                          width: 175
                      ),
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
            }else{
              var movies = snapshot.data?.reversed.toList();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var info = movies?[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                            child: FavoriteMovieCardWidget(posterUrl: info?['posterUrl'], movieName: info?['title'], imdbId: info?['imdbId']),
                          ),
                        ),
                        TextButton(onPressed: (){
                            removeFromList(info?['imdbId']);
                        }, child: Icon(Icons.delete , size:  30, color:  Colors.red,)),
                      ],
                    ),
                  );
                }
              );
            }
          }
      ),
    );
  }
}
