import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/product_model.dart';
import 'package:khind/screens/ewarranty_product.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Ewarranty extends StatefulWidget {
  const Ewarranty({Key? key}) : super(key: key);

  @override
  _EwarrantyState createState() => _EwarrantyState();
}

class _EwarrantyState extends State<Ewarranty> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();
  bool isAuth = false;

  @override
  void initState() {
    super.initState();

    checkIsAuth();
  }

  checkIsAuth() async {
    var auth = await storage.read(key: IS_AUTH);
    // print('#AUTH: $auth');

    setState(() {
      if (auth != null) {
        isAuth = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "E-Warranty", isBack: isAuth ? false : true, hasActions: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientButton(
              height: 40,
              child: Text(
                'Click here if you have a QR code',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'EwarrantyScanner',
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientButton(
              height: 40,
              child: Text(
                'Click here if you don\'t have a QR code',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () {
                Navigator.pushNamed(context, 'EwarrantyProductManual', arguments: true);
              },
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: (result != null)
          //         ? Text(
          //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         : Text('Scan a code'),
          //   ),
          // )
        ],
      ),
    );
  }
}
