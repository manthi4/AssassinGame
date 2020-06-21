import 'package:flutter/material.dart';
import 'package:assassingame/componants/bigButton.dart';
import 'package:assassingame/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:assassingame/user.dart';


class LoginScreen extends StatefulWidget {
  final bool loggingIn;
  LoginScreen({this.loggingIn});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var email;
  var password;

  void login() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if(user != null){
        await User.initialize();
        Navigator.pushNamed(context, HomePage.route);
      }
    }catch(e){
      print(e);
    }
  }

  void register() async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if(user != null){
        await User.initialize();
        Navigator.pushNamed(context, HomePage.route);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: getBorder(Colors.deepPurple),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'face',
                  child: Icon(
                    Icons.gps_fixed,
                    color: Colors.deepPurpleAccent,
                    size: 60,
                  ),
                ),
                Flexible(child: SizedBox(height: 100)),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: TextFieldStyle.copyWith(hintText: "Email"),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: TextFieldStyle,
                ),
                SizedBox(height: 20),
                widget.loggingIn
                    ? BigButton(
                        buttonText: "Login",
                        onClick: () {
                          login();
                        },
                      )
                    : BigButton(
                        buttonText: "Register",
                        onClick: () {
                          register();
                        },
                      )
              ]),
        ),
      ),
    );
  }
}

const TextFieldStyle = InputDecoration(
  hintText: 'Password',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);
