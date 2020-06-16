import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/detailsPage.dart';
import 'package:assassingame/screens/welcomPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: WelcomePage.route,
      routes: {
        HomePage.route :(context) => HomePage(),
        Details.route : (context) => Details(),
        WelcomePage.route:(context)=>WelcomePage(),
      },
    );
  }
}


