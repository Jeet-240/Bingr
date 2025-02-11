import "package:bingr/services/auth/auth_exceptions.dart";
import "package:bingr/services/auth/auth_provider.dart";
import "package:bingr/services/auth/auth_user.dart";
import "package:test/test.dart";



void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be Initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot log out before initialization' , (){
      expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    }
    );
    test('Should be able to Initialize', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initializartion' , (){
      expect(provider.currentUser, null);
    });

    test('Should be able to initialized in less than 2 seconds' , () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    } , timeout: const Timeout(Duration(seconds: 3)));

    test('Create user should delegate to logIn function', ()async{
      final badEmailUser = provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));
    });

    test('Create user should delegate to logIn function', ()async{
      final badPasswordUser = provider.createUser(email: 'someone@bar.com', password: 'foobar');
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));
    });

    test('positive scenario', () async{
      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });


    test('Logged in user should be able to get verified' , (){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again' , ()async{
      await provider.logOut();
      await provider.logIn(
          email: 'mail', password: 'password'
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

  }
  );
}


class NotInitializedException implements Exception{

}

class MockAuthProvider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async{
    // TODO: implement createUser
    if(!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser =>  _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    // TODO: implement logIn
    if(!isInitialized) throw NotInitializedException();
    if(email == 'foo@bar.com'){
      throw UserNotFoundAuthException();
    }if(password == 'foobar'){
      throw WrongPasswordAuthException();
    }
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    // TODO: implement logOut
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    // TODO: implement sendEmailVerification
    if(!isInitialized) throw NotInitializedException();
    final user  = _user;
    if(user == null){
      throw UserNotFoundAuthException();
    }else{
    const newUser =  AuthUser(isEmailVerified: true);
    _user = newUser;}
  }
    
}

