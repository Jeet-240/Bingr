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

}