import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/screens/ewarranty_product.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Ewarranty extends StatefulWidget {
  const Ewarranty({Key? key}) : super(key: key);

  @override
  _EwarrantyState createState() => _EwarrantyState();
}

class _EwarrantyState extends State<Ewarranty> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text('Please scan the product QR code'),
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
                      Navigator.pushNamed(
                        context,
                        'EwarrantyProductManual',
                      );
                    },
                  ),
                ),
              ],
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

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    Barcode barcode = await controller.scannedDataStream.first;

    print(barcode.code.toString());

    Navigator.pushNamed(
      context,
      'EwarrantyProduct',
      arguments: {'productModel': barcode.code.toString()},
    );

    // controller.scannedDataStream.listen((scanData) {

    // });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
