import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khind/screens/ewarranty.dart';
import 'package:khind/screens/ewarranty_product.dart';
import 'package:khind/screens/ewarranty_product_manual.dart';
import 'package:khind/screens/news.dart';
import 'package:khind/screens/splash.dart';
import 'package:khind/screens/signin.dart';
import 'package:khind/screens/signup.dart';
import 'package:khind/screens/forgot_password.dart';
import 'package:khind/screens/home.dart';

class AppRouter {
  static const String initialRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case 'signin':
        return MaterialPageRoute(builder: (_) => SignIn());
      case 'signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case 'forgot':
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case 'home':
        return MaterialPageRoute(builder: (_) => Home());
      case 'news':
        return MaterialPageRoute(builder: (_) => News());

      case 'ewarranty':
        return MaterialPageRoute(builder: (_) => Ewarranty());

      case 'EwarrantyProduct':
        if (arguments is Map) {
          return MaterialPageRoute(
            builder: (_) => EwarrantyProduct(
              arguments: arguments,
            ),
          );
        } else {
          return invalidArgument();
        }

      case 'EwarrantyProductManual':
        return MaterialPageRoute(
          builder: (_) => EwarrantyProductManual(),
        );

      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }

  static MaterialPageRoute<dynamic> invalidArgument() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('invalid arguments'),
        ),
      ),
    );
  }
}
