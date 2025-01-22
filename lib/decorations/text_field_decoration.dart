import 'package:bingr/constants/colors.dart';
import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String text , Icon icon){
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 16.0,
    ),
    prefixIcon: icon,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    hintText: text,
    hintStyle:
    const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
  );
}

TextStyle textFieldTextStyle(){
  return  TextStyle(
    color: primaryColor,
    fontFamily: 'Poppins',
    fontSize: 15,
  );

}
