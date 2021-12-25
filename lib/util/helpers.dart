import 'package:flutter/material.dart';

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
}
