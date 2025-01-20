import 'package:bingr/widgets/custom_button.dart';
import 'package:bingr/widgets/custom_dialogbox.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _emailController = TextEditingController();
  static final auth = AuthService.firebase().initialize();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(29, 22, 22, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(142, 22, 22, 1),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          'Please enter your email address to recover your password.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          controller: _emailController,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter your email here',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        CustomButton(
          onPressed: () async {
            final String email = _emailController.text.trim();
            if(email.isEmpty){
              await showErrorDialog(context, 'Please enter you email.');
            }
            try{
              await AuthService.firebase().resetPassword(email: email);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                  const Text('Email sent, please check you mail.'),
                  dismissDirection: DismissDirection.startToEnd,
                  duration: const Duration(seconds: 15),
                ),
              );
              Future.delayed(const Duration(seconds: 4) , (){Navigator.of(context).pop();});
            }
            on InvalidEmail{
              showErrorDialog(context, 'Please enter valid email-id.');
            }
            on UserNotFoundAuthException{
              showErrorDialog(context, 'User not found, please enter valid email-id');
            }
            catch(e){
              showErrorDialog(context, e.toString());
            }
          },
          text: 'RECOVER PASSWORD',
        ),
      ]),
    );
  }
}
