import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khind/screens/splash.dart';
import 'package:khind/screens/signin.dart';
import 'package:khind/screens/signup.dart';
import 'package:khind/screens/home.dart';

class AppRouter {
  static const String initialRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case 'signin':
        return MaterialPageRoute(builder: (_) => SignIn());
      case 'signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }
}
