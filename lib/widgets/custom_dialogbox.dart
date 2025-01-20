import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context , String text){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Color.fromRGBO(30, 30, 30, 1),
        title: const Text(
            'Error!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
        ),
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
            Navigator.of(context).pop(false);
          },
          child: Text(
            'OK' ,
            style: TextStyle(color: Color.fromRGBO(255 , 0 , 0 , 1)),
            ),
          ),
        ],
      );
    });
}