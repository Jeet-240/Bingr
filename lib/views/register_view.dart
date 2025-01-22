import 'package:bingr/animation/text_animation.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/decorations/text_field_decoration.dart';
import '/constants/routes.dart';
import '/services/auth/auth_exceptions.dart';
import '/services/auth/auth_service.dart';
import '/widgets/custom_dialogbox.dart';
import '/widgets/custom_button.dart';
import 'package:flutter/material.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _username;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implemenbot dispose
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: backgroundColor,
       appBar: animatedAppName(),
       resizeToAvoidBottomInset: false,
       body: Column(
         children: [
           Expanded(
             child: ListView(
               padding: EdgeInsets.only(left: 15 , right: 15),
               scrollDirection: Axis.vertical,
               children: [
                 Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(top: 50),
                      child: Image(
                        image: AssetImage('assets/images/signIn.png'),
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
                      decoration: textFieldDecoration('Enter you email', Icon(Icons.email_outlined)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        style: textFieldTextStyle(),
                        controller: _username,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: textFieldDecoration('Enter Your username', Icon(Icons.account_box_outlined)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        style: textFieldTextStyle(),
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: textFieldDecoration('Enter Your password', Icon(Icons.password)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30 , bottom: 10),
                      child: CustomButton(
                          text: 'Register',
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            final username = _username.text;
                            if(email.isEmpty && password.isEmpty){
                              await showErrorDialog(context, 'Enter both the fields.');
                            }
                            else if(email.isEmpty){
                              await showErrorDialog(context, 'Email field cannot be empty.');
                            }
                            else if(password.isEmpty){
                              await showErrorDialog(context, 'Password field cannot be empty.');}

                            try {
                                  await AuthService.firebase().createUser(
                                  email: email,
                                  password: password,
                                    username: username,
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil(verifyRoute, (route)=>false);
                            } on WeakPasswordAuthException {
                              await showErrorDialog(context, 'The password is too weak. Please choose a stronger password.');
                            } on EmailAlreadyInUseAuthException{
                              await showErrorDialog(context, 'Email already in use, please sign in or user another email.');
                            } on InvalidAuthException{
                              await showErrorDialog(context, 'The email entered is invalid. Please enter a valid email address.');
                            }on TooManyRequest{
                              await showErrorDialog(context, 'Too many login attempts, please try again later.');
                            } on InvalidEmail{
                              await showErrorDialog(context, 'Invalid email format, please check and type again.');
                            } on NetworkRequestFailed{
                              await showErrorDialog(context, 'Network Request Failed please check your connection.');
                            }catch(e){
                              await showErrorDialog(context, e.toString());
                            }
                          }
                      ),
                    ),
                  ]
                   )],
             ),
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
                   "Already have an account?",
                   style: TextStyle(
                       color: Colors.white
                   ),
                 ),
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).pushNamedAndRemoveUntil(
                     loginRoute,
                     (route)=>false,);
                   },
                   child: const Text(
                     'Log In',
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


