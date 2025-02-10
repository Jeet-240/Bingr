import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 400,
        maxWidth: 400,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            height: 150,
            width: 150
          ),
          SizedBox(height: 10),
          Text(
            'Gah! Some Error Occurred. Please Retry',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
