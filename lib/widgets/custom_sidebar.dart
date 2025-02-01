import 'package:bingr/constants/colors.dart';
import 'package:bingr/constants/routes.dart';
import 'package:bingr/constants/urls.dart';
import 'package:bingr/services/auth/auth_service.dart';
import 'package:bingr/views/more_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: sideBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: sideBarColor,
              ), //BoxDecoration
              child: Row(
                spacing: 20,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ), //Text
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Welcome!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Abhishek Mishra",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                  "abhishekm977@gmail.com",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                        ]),
                  ),
                ],
              ) //UserAccountDrawerHeader
              ), //DrawerHeader
          ListTile(
            leading: const Icon(Icons.movie_creation_sharp, color: Colors.red),
            title: const Text(
              ' My Course ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: MorePage(
                        category: MovieCardApi.popularMovies,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv, color: Colors.yellow),
            title: const Text(
              'TV Shows',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: MorePage(
                        category: MovieCardApi.popularShows,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.pink),
            title: const Text(
              'Favorites',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: MorePage(
                        category: MovieCardApi.popularShows,
                      )));
            },
          ),
          Spacer(),
          Container(
            height: 2,
            width: double.infinity,
            color: Colors.white,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: const Text(
              'LogOut',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);
                await AuthService.firebase().logOut();
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogBoxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          shadowColor: Colors.white24,
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text('Are you sure you want to sign out?',
              style: TextStyle(
                fontWeight: FontWeight.w400,
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
                    fontWeight: FontWeight.w300,
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
                    color: confirmationButtonColor,
                    fontFamily: 'Poppins',
                  )),
            )
          ],
        );
      }).then((value) => value ?? false);
}
