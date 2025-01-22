import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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
