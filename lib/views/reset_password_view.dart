import 'package:bingr/animation/text_animation.dart';
import 'package:bingr/decorations/text_field_decoration.dart';
import 'package:bingr/widgets/custom_button.dart';
import 'package:bingr/widgets/custom_dialogbox.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _email;
  static final auth = AuthService.firebase().initialize();


  @override
  void initState(){
    _email = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: animatedAppBar(),
      body: Column(children: [
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
                  spacing: 30,
                  children: [
                    TextField(
                        autofocus: true,
                        style: textFieldTextStyle(),
                        controller: _email,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFieldDecoration(
                            'Enter your email', Icon(Icons.email_outlined))),
                    CustomButton(
                      onPressed: () async {
                        final String email = _email.text.trim();
                        if(email.isNotEmpty){
                        try {
                          await AuthService.firebase().resetPassword(email: email).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Email sent, please check you mail.'),
                                dismissDirection: DismissDirection.startToEnd,
                                duration: const Duration(seconds: 15),
                              ),
                            );
                          });
                        } on InvalidEmail {
                          showErrorDialog(context, 'Please enter valid email-id.');
                        } on UserNotFoundAuthException {
                          showErrorDialog(
                              context, 'User not found, please enter valid email-id');
                        } catch (e) {
                          showErrorDialog(context, e.toString());
                        }
                      }
                        else{
                          await showErrorDialog(context, 'Enter your email in the field.');
                        }
                      },
                      text: 'RECOVER PASSWORD',
                    )
                  ],
                )
              ),
            ]),),

      ]),
    );
  }
}



