import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/screens/signin.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final storage = new FlutterSecureStorage();
  bool isLoading = false;

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      _validateToken();
    });

    super.initState();
  }

  _validateToken() async {
    String? token = await storage.read(key: TOKEN);

    if (token != null) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'signin');
    }
  }

  Widget _renderHeader() {
    return Container(
        alignment: Alignment.center,
        child: Image(
            image: AssetImage('assets/images/logo_text.png'),
            height: MediaQuery.of(context).size.width * 0.2));
  }

  Widget _renderLoading() {
    return CircularProgressIndicator(color: AppColors.primary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_renderHeader(), SizedBox(height: 50), _renderLoading()])),
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
