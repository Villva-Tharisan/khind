import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
      Alert(
        context: ctx,
        type: AlertType.warning,
        title: title,
        desc: desc,
        buttons: [
          DialogButton(
            child: Text(
              okTitle != null ? okTitle : "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => onPressed(),
            gradient: LinearGradient(
                colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
          ),
          hasCancel
              ? DialogButton(
                  child: Text(
                    noTitle != null ? noTitle : "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(188, 188, 188, 1.0),
                    Color.fromRGBO(209, 209, 209, 1.0),
                  ]),
                )
              : DialogButton(onPressed: () {}, child: Container())
        ],
      ).show();
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

  static AppBar customAppBar(BuildContext ctx, GlobalKey<ScaffoldState> scaffoldKey,
      {String title = "", bool isBack = false, hasActions = true}) {
    return AppBar(
      leadingWidth: isBack ? 50 : 20,
      leading: isBack
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue[500], size: 30),
              onPressed: () {
                if (!isBack) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  Navigator.of(ctx).pop();
                }
              })
          : Container(),
      backgroundColor: HexColor('#373A36'),
      elevation: 0.0,
      titleSpacing: 0,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: hasActions
          ? [
              new IconButton(
                  color: Colors.transparent,
                  // iconSize: 10,
                  icon: Image(image: AssetImage('assets/icons/location.png'), height: 32),
                  onPressed: () {
                    Navigator.pushNamed(ctx, 'service_locator');
                  }),
              SizedBox(width: 5),
              new IconButton(
                  color: Colors.transparent,
                  // iconSize: 10,
                  icon: Image(image: AssetImage('assets/icons/user.png'), height: 27),
                  onPressed: () {
                    Navigator.pushNamed(ctx, 'profile');
                  }),
              SizedBox(width: 5)
            ]
          : [],
    );
  }
}
