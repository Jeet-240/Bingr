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
    fillColor: textFieldFillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    hintText: text,
    hintStyle:
    const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
  );
}

TextStyle textFieldTextStyle(){
  return  TextStyle(
    color: textFieldColor,
    fontFamily: 'Poppins',
    fontSize: 15,
  );

}
