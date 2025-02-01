import 'package:bingr/constants/colors.dart';
import 'package:bingr/constants/urls.dart';
import 'package:bingr/views/more_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import '/constants/key.dart';
import '/services/auth/auth_service.dart';
import '/views/main_view.dart';
import 'views/authentication/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/authentication/login_view.dart';
import 'views/authentication/register_view.dart';
import 'constants/routes.dart';




void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    color: backgroundColor,
    home: HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      mainRoute: (context) => const MainView(),
      verifyRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool check = false;
  @override
  void initState(){
    super.initState();
    _checkLogInStatus();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        AuthService.firebase().initialize(),
        _checkLogInStatus()]),
      builder: (context, snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            {
              if(check){
                return MainView();
              }else{
                return LoginView();
              }
            }
          default:
            {
              return CircularProgressIndicator();
            }
        }
      },
    );
  }

  Future<void> _checkLogInStatus() async{
    final prefs = await SharedPreferences.getInstance();
    var login = prefs.getBool('isLoggedIn');
    if(login!=null){
      if(login){
        check = true;
      }else{
        check = false;
      }
    }else{
      check = false;
    }
  }
}
