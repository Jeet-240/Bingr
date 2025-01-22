import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bingr/constants/colors.dart';
import 'package:flutter/material.dart';

AppBar animatedAppName([List<Widget>?actions]) {
  return AppBar(
    backgroundColor: primaryColor,
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
              'Bingr',
            speed: const Duration(seconds: 1),
          ),
        ]),
    actions: actions,
  );
}
