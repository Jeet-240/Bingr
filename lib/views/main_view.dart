import 'package:bingr/animation/text_animation.dart';
import 'package:bingr/constants/colors.dart';
import '/constants/routes.dart';
import '/examples/write_examples.dart';
import '/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '/enums/menu_action.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../examples/read_examples.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          width: 250,
          backgroundColor: primaryColor,

        ),
        backgroundColor: backgroundColor,
        appBar: animatedAppName(
          [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    // TODO: Handle this case.
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('isLoggedIn', false);
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log Out'),
                  )
                ];
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Check out out example'),
              SizedBox(
                height: 6,
                width: MediaQuery.of(context).size.width,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReadExamples()));
                },
                child: Text('Read Example'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WriteExamples()));
                },
                child: Text('Write Example'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          shadowColor: Colors.white54,
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Poppins',
              )),
          actions: [
            TextButton(
              style: ButtonStyle(),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  )),
            )
          ],
        );
      }).then((value) => value ?? false);
}
