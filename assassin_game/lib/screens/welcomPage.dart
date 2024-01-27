import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:assassingame/componants/bigButton.dart';
import 'loginScreen.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatelessWidget {
  static final route = "welcome";
  final _auth = FirebaseAuth.instance;

  void checkStatus(context) async {
    final user = await _auth.currentUser();
    if (user != null) {
      print("User already logged in");
      await User.initialize();
      Navigator.pushNamed(context, HomePage.route);
    }
  }
  // void checkStatus(context)async{
  //   final user = await _auth.currentUser();
  //   if(user != null){
  //     print("User already logged in");
  //     await User.initialize();
  //     Navigator.pushNamed(context, HomePage.route);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    checkStatus(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: getBorder(Colors.purple),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'face',
                  child: Icon(
                    Icons.gps_fixed,
                    color: Colors.purpleAccent,
                    size: 60,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextLiquidFill(
                  text: "Assassin",
                  waveColor: Colors.purpleAccent,
                  //boxBackgroundColor: Colors.redAccent,
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 50.0,
                ),
                BigButton(
                  buttonText: "Login",
                  onClick: () {
                    print("tried to login");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  loggingIn: true,
                                )));
                  },
                ),
                BigButton(
                  buttonText: "Register",
                  onClick: () {
                    print("tried to Register");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  loggingIn: false,
                                )));
                  },
                )
              ]),
        ),
      ),
    );
  }
}
