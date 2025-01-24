import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bingr/constants/colors.dart';
import 'package:flutter/material.dart';




class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  List<Widget>actions;
  Color appBarColor;
  AnimatedAppBar({Key? key , required this.actions , required this.appBarColor}) : super(key:  key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      titleTextStyle: TextStyle(
        fontFamily: "LogoFont",
        color: topLogoColor,
        fontWeight: FontWeight.w500,
        fontSize: 30,
      ),
      title: AnimatedTextKit(
          isRepeatingAnimation: true,
          repeatForever: true,
          animatedTexts: [
            TypewriterAnimatedText(
              textAlign: TextAlign.center,
              'Bingr',
              speed: const Duration(seconds: 1),
            ),
          ]),
      actions: actions,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

AnimatedAppBar animatedAppBar(List<Widget>actions , Color appBarColor){
    return AnimatedAppBar(actions: actions , appBarColor: appBarColor,);
}



