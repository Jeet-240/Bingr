import 'package:bingr/views/homepage/carousel_slider.dart';
import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter/material.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: animatedAppBar([], mainAppbarColor),
      endDrawer: ExampleSidebarX(controller: SidebarXController(selectedIndex: 0)),
      body: MyCarouselSlider(),
    );
  }
}
