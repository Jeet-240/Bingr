import 'package:bingr/constants/urls.dart';
import 'package:bingr/views/homepage/carousel_slider.dart';
import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter/material.dart';

import 'homepager_rows.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});
  static const EdgeInsets margin = EdgeInsets.only(top: 10 , bottom: 10, left: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: animatedAppBar([], mainAppbarColor),
      endDrawer: ExampleSidebarX(controller: SidebarXController(selectedIndex: 0)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              Container(
                margin: margin,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Popular Indian Movies',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
              ),
              MyCarouselSlider(),
              Container(
                margin: margin,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Shows',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
              HomepageRows(type: MovieCardApi.popularShows),
              Container(
                margin: margin,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Movies',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
              HomepageRows(type: MovieCardApi.popularMovies),
        ]),
      ),
    );
  }
}
