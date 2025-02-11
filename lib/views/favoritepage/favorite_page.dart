import 'package:bingr/services/api/Api_service.dart';
import 'package:bingr/services/auth/auth_service.dart';
import 'package:bingr/widgets/favorite_movie_card.dart';
import 'package:flutter/material.dart';
import 'package:bingr/services/database/firebase_database_service.dart';

import '../../constants/colors.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseDatabaseProvide firebaseDatabaseProvide = FirebaseDatabaseProvide();
    final uid = AuthService.firebase().currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
          title: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Favorites',
              style: TextStyle(
                  color: Color.fromRGBO(250, 240, 230, 1),
                  fontWeight: FontWeight.w700),
            ),
          )),
      backgroundColor: backgroundColor,
      body: FutureBuilder(
          future: firebaseDatabaseProvide.fetchWishlist(uid: uid),
          builder: (context , snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 300,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: dialogBoxColor,
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 250 ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Error: ${snapshot.error}"),
                    ElevatedButton(
                      onPressed: (){},
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ConstrainedBox(
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
                        height: 150,
                        width: 150
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Movies Added in the list!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            }else{
              var data = snapshot.data;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var info = snapshot.data?[index];
                  print(info!['posterUrl']);
                  return SizedBox(
                    height: 250,
                    child: FavoriteMovieCardWidget(posterUrl: info!['posterUrl'].toString(), movieName: info['title'].toString(), imdbId: info['moveId'].toString()),
                  );
                }
              );
            }
          }
      ),
    );
  }
}
