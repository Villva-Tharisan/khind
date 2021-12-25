import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khind/screens/signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(context, 'home');
      // Navigator.pushNamed(context, 'signup');
      // Navigator.pushNamed(context, 'signin');

      // Navigator.of(context).push(new SignInPageRoute());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(alignment: Alignment.center, child: Text("Loading...")),
    );
  }
}

class SignInPageRoute extends CupertinoPageRoute {
  SignInPageRoute() : super(builder: (BuildContext context) => new SignIn());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new ScaleTransition(scale: animation, child: new SignIn());
    // return new FadeTransition(opacity: animation, child: new SignIn());
  }
}
