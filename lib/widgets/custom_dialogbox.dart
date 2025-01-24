import 'package:bingr/constants/colors.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context , String text){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: dialogBoxColor,
        shadowColor: Colors.white24,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        title: const Text(
            'Error!',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
        ),
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,

          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
            Navigator.of(context).pop(false);
          },
          child: Text(
            'OK' ,
            style: TextStyle(
                color: confirmationButtonColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
            ),
          ),
        ],
      );
    });
}