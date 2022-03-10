import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/service_product.dart';
import 'package:khind/models/shipping_address.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  static void showAlert(BuildContext ctx,
      {child,
      title,
      desc,
      onPressed,
      hasAction = false,
      okTitle = "Ok",
      noTitle = "Cancel",
      hasCancel = false}) {
    if (hasAction) {
      List<DialogButton> actionButtons = [];
      if (hasCancel) {
        actionButtons = [
          DialogButton(
            child: Text(
              okTitle != null ? okTitle : "Ok",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            color: AppColors.primary,
            onPressed: () => onPressed(),
            // gradient: LinearGradient(
            //     colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]
            // ),
          ),
          DialogButton(
            child: Text(
              noTitle != null ? noTitle : "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            border: Border.all(width: 1, color: Colors.grey[300]!),
            color: Colors.grey[400],
            onPressed: () => Navigator.pop(ctx),
          )
        ];
      } else {
        actionButtons = [
          DialogButton(
            child: Text(
              okTitle != null ? okTitle : "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => onPressed(),
            color: AppColors.primary,
          )
        ];
      }

      Alert(
              context: ctx,
              type: AlertType.warning,
              title: title,
              style: AlertStyle(animationDuration: Duration(milliseconds: 400)),
              desc: desc,
              buttons: actionButtons,
              alertAnimation: fadeAlertAnimation)
          .show();
    } else {
      AlertDialog alert;
      alert = AlertDialog(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 5), child: Text("Loading...")),
          ],
        ),
      );

      showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  static Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static AppBar customAppBar(BuildContext ctx, GlobalKey<ScaffoldState> scaffoldKey,
      {String title = "", Widget? customTitle, bool isBack = false, hasActions = true}) {
    return AppBar(
      leadingWidth: isBack ? 50 : 20,
      leading: isBack
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.secondary, size: 20),
              onPressed: () {
                if (!isBack) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  Navigator.of(ctx).pop();
                }
              })
          : Container(),
      backgroundColor: AppColors.primary,
      elevation: 0.0,
      titleSpacing: 0,
      centerTitle: false,
      title: customTitle != null
          ? customTitle
          : Text(
              title,
              style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
            ),
      actions: hasActions
          ? [
              new InkWell(
                  // color: Colors.transparent,
                  // icon: Image(image: AssetImage('assets/icons/location.png'), height: 22),
                  child: Icon(Icons.location_pin, size: 27, color: AppColors.secondary),
                  onTap: () {
                    Navigator.pushNamed(ctx, 'service_locator');
                  }),
              SizedBox(width: 5),
              new InkWell(
                  child: Icon(Icons.account_circle_rounded, size: 27, color: AppColors.secondary),
                  onTap: () {
                    Navigator.pushNamed(ctx, 'profile');
                  }),
              SizedBox(width: 10)
            ]
          : [],
    );
  }

  static Purchase? purchase;

  static Future<void> launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewOrVC(String url) async {
    if (!await launch(url,
        forceSafariVC: true, forceWebView: true, enableDomStorage: true, enableJavaScript: true)) {
      throw 'Could not launch $url';
    }
  }

  static bool? fromSignIn = false;

  //service tracker global var
  static ProductWarranty? productWarranty;
  static ServiceProduct? serviceProduct;
  static int? productIndex;
  static ShippingAddress? userAddress;
}
