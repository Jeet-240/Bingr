import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../classes/user_info.dart';

class FirebaseDatabaseProvide{
  FirebaseDatabase init() {
    final databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
        'https://bingr-8d054-default-rtdb.asia-southeast1.firebasedatabase.app/');
    return databaseRef;
  }

  Future<void> storeUserData({
    required String? userId,
    required String email,
    required String username,
  })async {
    final databaseRef = init().ref('users');

    try{
      await databaseRef.child(userId!).set({
        'username' : username,
        'userId' : userId,
        'email' : email,
      });
    }catch(e){
      rethrow;
    }
  }

  Future<UserInformation> fetchUserData({required String uid}) async {
    try {
      final databaseRef = init().ref('users').child(uid);
      DataSnapshot snapshot = await databaseRef.get();
      Map<String , dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
      return UserInformation(
        username: userData['username'] ?? '',
        email: userData['email'] ?? '',
      );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }


  Future<void> addToWishlist({required String uid,required String imdbId, required String title, required String posterUrl}) async {
    final databaseRef = init().ref("wishlist/$uid/$imdbId");
    await databaseRef.set({
      "title" : title,
      "posterUrl" : posterUrl,
      "addedTime" : DateTime.now().toIso8601String()
    });
  }

  Future<void> removeFromWishList({required String uid, required String imdbId}) async {
    final databaseRef = init().ref('wishlist/$uid/$imdbId');
    await databaseRef.remove();
  }


  Future<List<Map<String, dynamic>>> fetchWishlist({required String uid}) async{
    final databaseRef = init().ref('wishlist/$uid');
    DatabaseEvent databaseEvent = await databaseRef.once();
    Map<dynamic,dynamic> wishListMap = databaseEvent.snapshot.value as Map;

    return wishListMap.entries.map((entry){
      return{
        "movieId": entry.key,
        "title": entry.value['title'],
        "posterUrl": entry.value['posterUrl'],
        "added" : entry.value['addedTime'],
      };
    }).toList();
  }


  Future<bool> checkInDatabase({required String uid , required String imdbId}) async{
    final databaseRef = init().ref('wishlist/$uid/$imdbId');
    DatabaseEvent databaseEvent = await databaseRef.once();
    return databaseEvent.snapshot.value!=null;
  }
 }