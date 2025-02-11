import 'package:bingr/constants/urls.dart';
import 'package:bingr/views/homepage/carousel_slider.dart';
import 'package:bingr/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/animated_app_bar.dart';
import 'homepager_rows.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const EdgeInsets margin = EdgeInsets.only(top: 10 , bottom: 10, left: 10);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: animatedAppBar([], mainAppbarColor),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              Container(
                margin: Homepage.margin,
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
                margin: Homepage.margin,
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
                margin: Homepage.margin,
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
