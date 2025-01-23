import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/constants/routes.dart';
import '../constants/colors.dart';
import '../services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: animatedAppBar([], authAppbarColor),
      body:  Column(children: [
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              height: 200,
              margin: EdgeInsets.only(top: 50),
              child: Image(
                image: AssetImage('assets/images/reset-password.png'),
                width: 150,
                height: 150,
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 15 , right: 15),
                child: Column(
                  spacing: 15,
                  children: [
                    Text(
                      'We have sent you email!\n Please check your mail.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                    CustomButton(
                        onPressed: () async {
                          final user = AuthService.firebase().currentUser;
                          final isUserVerified = user?.isEmailVerified ?? false;
                          if(!isUserVerified){
                            await AuthService.firebase().sendEmailVerification();
                          }else{
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute,
                                  (route)=>false,
                            );
                          }
                        },
                        text:  'Resend Email Verification'
                    ),
                    CustomButton(
                        onPressed: () async {
                          final user = AuthService.firebase().currentUser;
                          final isUserVerified = user?.isEmailVerified ?? false;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/',
                                  (route)=>false,
                            );
                        },
                        text:  'Return to Login Page.'
                    ),
                  ],
                )
            ),
          ]),),

      ]),
    );
  }
}


