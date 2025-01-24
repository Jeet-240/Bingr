import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MovieInfoPage extends StatelessWidget {
  const MovieInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: animatedAppBar([] , mainAppbarColor),
      backgroundColor: backgroundColor,
      drawer: ExampleSidebarX(controller: SidebarXController(selectedIndex: 0)),
    );
  }
}
