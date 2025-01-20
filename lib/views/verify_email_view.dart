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
      backgroundColor:Color.fromRGBO( 29, 22, 22  ,  1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO( 142 , 22, 22  , 1),
          title: const Text(
              'Verify Email',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
      body: Column(
        children: [
          Text(
              'Please Verify your email address',
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          CustomButton(
              onPressed: () async {
                final user = AuthService.firebase().currentUser;
                final isUserVerified = user?.isEmailVerified ?? false;
                if(!isUserVerified){
                      await AuthService.firebase().sendEmailVerification();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                            (route)=>false,
                      );
                }else{
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                        (route)=>false,
                  );
                }
              },
              text:  'Send email Verification'
          ),
        ],
      ),
    );
  }
}