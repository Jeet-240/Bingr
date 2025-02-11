import 'package:bingr/services/database/firebase_database_service.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_service.dart';
import 'auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
        show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvide implements AuthProvider{
  @override
  Future<AuthUser> createUser({required String email, required String password,required String username}) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      final user = currentUser;
      if(user!=null){
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        await AuthService.firebase().sendEmailVerification().then((_){
          FirebaseDatabaseProvide provider = FirebaseDatabaseProvide();
          provider.storeUserData(userId: userId, email: email, username: username);
        });
        return user;
      }else{
        throw UserNotLoggedInAuthException();
      }
    }on FirebaseAuthException catch(e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmail();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      }else if(e.code == 'too-many-requests'){
        throw TooManyRequest();
      } else if(e.code == 'network-request-failed'){
        throw NetworkRequestFailed();
      }
    }catch(e){
      throw GenericAuthException();}

    throw UserNotLoggedInAuthException();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
   final user = FirebaseAuth.instance.currentUser;
   if(user!=null){
     return AuthUser.fromFirebase(user);
   }else{
     return null;
   }
  }


  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
    }) async{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
        );
        final user = currentUser;
        if(user!=null){
          return user;
        }else{
          throw UserNotLoggedInAuthException();
        }
      } on FirebaseAuthException catch(e){
        if (e.code == 'user-not-found') {
         throw UserNotFoundAuthException();
        } else if (e.code == 'wrong-password') {
          throw WrongPasswordAuthException();
        }else if(e.code == 'invalid-email'){
          throw InvalidAuthException();
        } else if(e.code == 'too-many-requests'){
          throw TooManyRequest();
        } else if(e.code == 'network-request-failed'){
          throw NetworkRequestFailed();
        }
      }catch(e){
        throw GenericAuthException();}

      throw UserNotLoggedInAuthException();

  }

  @override
  Future<void> logOut() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await FirebaseAuth.instance.signOut();
    }else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.sendEmailVerification();
    }else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async{
    try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(e){
      if(e.code == 'invalid-email'){
        throw InvalidEmail();
      }
      else if(e.code == 'user-not-found'){
        throw UserNotFoundAuthException();
      }
    }catch(e){
      throw GenericAuthException();
    }
  }


}