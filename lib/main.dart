import 'package:bingr/constants/colors.dart';
import 'package:bingr/views/searchpage/search_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  static bool isLoggedIn   = false;
  @override
  void initState(){
    super.initState();
    _intialize();
  }


  Future<void> _intialize() async{
    await AuthService.firebase().initialize();
    isLoggedIn = await _checkLogInStatus();

    // Remove splash screen after everything is ready
    FlutterNativeSplash.remove();

    setState(() {});
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
              if(isLoggedIn){
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

  Future<bool> _checkLogInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Returns false if null
  }
}
