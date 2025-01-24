import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/decorations/text_field_decoration.dart';
import 'package:bingr/views/authentication/reset_password_view.dart';
import 'package:page_transition/page_transition.dart';
import '/constants/routes.dart';
import '/services/auth/auth_service.dart';
import '/widgets/custom_dialogbox.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_button.dart';
import '/services/auth/auth_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: animatedAppBar([] , authAppbarColor),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: ListView(scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(left: 15 , right: 15),
                children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: 200,
                  margin: EdgeInsets.only(top: 50),
                  child: Image(
                    image: AssetImage('assets/images/login.png'),
                    width: 150,
                    height: 150,
                  ),
                ),
                TextField(
                    style: textFieldTextStyle(),
                    controller: _email,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: textFieldDecoration(
                        'Enter your email', Icon(Icons.email_outlined))),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                      style: textFieldTextStyle(),
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: textFieldDecoration(
                          'Enter you password', Icon(Icons.password))),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 5 , bottom: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            PageTransition(type: PageTransitionType.bottomToTopPop ,childCurrent: widget, child: ResetPasswordView()));
                      },
                      child: const Text(
                          'Forgotten Password?',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.w700
                          ),),
                    ),
                  ),
                ),
                CustomButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    if (email.isEmpty && password.isEmpty) {
                    await showErrorDialog(context, 'Enter both the fields.');
                    }
                    else if (email.isEmpty) {
                      await showErrorDialog(
                          context, 'Email field cannot be empty.');
                    }
                    else if (password.isEmpty) {
                      await showErrorDialog(
                          context, 'Password field cannot be empty.');
                    }
                    try {
                      await AuthService.firebase()
                          .logIn(email: email.trim(), password: password.trim());
                      final user = AuthService.firebase().currentUser;
                      if (user != null) {
                        final isEmailVerified = user.isEmailVerified;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);
                        if (!isEmailVerified) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                              verifyRoute, (route) => false);
                        } else {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(mainRoute, (route) => false);
                        }
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                          context, 'User not found, please register first.');
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                          context, 'Wrong Password, please try again.');
                    } on GenericAuthException {
                      await showErrorDialog(
                          context, 'An error occurred, please try again');
                    } on TooManyRequest {
                      await showErrorDialog(context,
                          'Too many login attempts, please try again later.');
                    } on InvalidEmail {
                      await showErrorDialog(context,
                          'Invalid email format, please check and type again.');
                    } on NetworkRequestFailed {
                      await showErrorDialog(context,
                          'Network Request Failed please check your connection.');
                    }
                  },
                  text: 'Login',
                ),
              ]),
                ]),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15 , left: 15 , right: 15),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Don't have an account?",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      registerRoute,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w700
                    ),),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
