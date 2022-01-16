import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khind/cubit/product_group/product_group_cubit.dart';
import 'package:khind/cubit/product_model/product_model_cubit.dart';
import 'package:khind/models/news.dart';
import 'package:khind/screens/ewarranty.dart';
import 'package:khind/screens/ewarranty_product.dart';
import 'package:khind/screens/ewarranty_product_manual.dart';
import 'package:khind/screens/ewarranty_scanner.dart';
import 'package:khind/screens/extend_warranty.dart';
import 'package:khind/screens/news_landing.dart';
import 'package:khind/screens/news_detail.dart';
import 'package:khind/screens/product_model.dart';
import 'package:khind/screens/profile.dart';
import 'package:khind/screens/request_date.dart';
import 'package:khind/screens/request_date_dropin.dart';
import 'package:khind/screens/request_service_locator.dart';
import 'package:khind/screens/service_tracker_details.dart';
import 'package:khind/screens/servicelocator.dart';
import 'package:khind/screens/splash.dart';
import 'package:khind/screens/signin.dart';
import 'package:khind/screens/signup.dart';
import 'package:khind/screens/forgot_password.dart';
import 'package:khind/screens/home.dart';

import 'models/Purchase.dart';
import 'screens/request_date_pickup.dart';
import 'screens/service_type.dart';

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
      case 'profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case 'home':
        return MaterialPageRoute(builder: (_) => Home());
      case 'news':
        return MaterialPageRoute(builder: (_) => NewsLanding());
      case 'news_detail':
        return MaterialPageRoute(
            builder: (_) => NewsDetail(data: arguments as News));
      case 'service_locator':
        return MaterialPageRoute(builder: (_) => ServiceLocator());
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProductGroupCubit(),
              ),
              BlocProvider(
                create: (context) => ProductModelCubit(),
              ),
            ],
            child: EwarrantyProductManual(),
          ),
        );

      case 'productModel':
        return MaterialPageRoute(
            builder: (_) => ProductModel(data: arguments as Purchase));

      case 'serviceType':
        return MaterialPageRoute(
            builder: (_) => ServiceType(data: arguments as Purchase));

      case 'requestDate':
        return MaterialPageRoute(builder: (_) => RequestDate());
      case 'requestDateDropIn':
        return MaterialPageRoute(builder: (_) => RequestDateDropIn());
      case 'requestDatePickup':
        return MaterialPageRoute(builder: (_) => RequestDatePickup());

      case 'requestServiceLocator':
        return MaterialPageRoute(builder: (_) => ServiceRequestLocator());

      case 'ExtendWarranty':
        return MaterialPageRoute(builder: (_) => ExtendWarranty());

      // case 'ServiceTrackerDetails':
      //   return MaterialPageRoute(builder: (_) => ServiceTrackerDetails());

      case 'EwarrantyScanner':
        return MaterialPageRoute(builder: (_) => EwarrantyScanner());

      case 'ServiceTrackerDetails':
        if (arguments is Map) {
          return MaterialPageRoute(
            builder: (_) => ServiceTrackerDetails(
              arguments: arguments,
            ),
          );
        } else {
          return invalidArgument();
        }

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
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
