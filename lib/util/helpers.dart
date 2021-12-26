import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Helpers {
  static void showAlert(BuildContext ctx,
      {child, onPressed, hasAction = false, hasCancel = false}) {
    AlertDialog alert;

    if (hasAction) {
      alert = AlertDialog(
        content: child,
        actions: <Widget>[
          MaterialButton(child: Text('Ok'), onPressed: () => onPressed()),
          hasCancel
              ? MaterialButton(child: Text('Ok'), onPressed: () => Navigator.pop(ctx))
              : Container()
        ],
      );
    } else {
      alert = AlertDialog(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 5), child: Text("Loading...")),
          ],
        ),
      );
    }

    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static AppBar customAppBar(BuildContext ctx, GlobalKey<ScaffoldState> scaffoldKey,
      {String title = "", bool isBack = false, hasActions = true}) {
    return AppBar(
      // leadingWidth: isBack ? 30 : 20,
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
      backgroundColor: Colors.grey[200],
      elevation: 0.0,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: hasActions
          ? [
              new IconButton(
                  color: Colors.transparent,
                  icon: Image(image: AssetImage('assets/icons/location.png')),
                  onPressed: () {
                    Navigator.pushNamed(ctx, 'service_locator');
                  }),
              SizedBox(width: 5),
              new IconButton(
                  icon: Image(image: AssetImage('assets/icons/user.png')),
                  onPressed: () {
                    Navigator.pushNamed(ctx, 'profile');
                  }),
              SizedBox(width: 5)
            ]
          : [],
    );
  }
}
