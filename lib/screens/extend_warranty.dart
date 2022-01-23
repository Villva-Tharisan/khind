import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/util/helpers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ExtendWarranty extends StatefulWidget {
  const ExtendWarranty({Key? key}) : super(key: key);

  @override
  State<ExtendWarranty> createState() => _ExtendWarrantyState();
}

class _ExtendWarrantyState extends State<ExtendWarranty> {
  late String chosenProductModel;

  late Purchase purchase;

  late DateTime purchaseDate;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    purchase = Helpers.purchase!;
    purchaseDate = DateTime.parse(purchase.purchaseDate!);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime now = DateTime.now();

  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Extend Warranty'),
      // ),

      appBar: Helpers.customAppBar(
        context,
        _scaffoldKey,
        title: "Extend Warranty",
        hasActions: false,
        isBack: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.5,
                    color: Colors.grey,
                    spreadRadius: 0.5,
                    // offset:
                  ),
                ],
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.productGroupDescription!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(purchase.modelDescription!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text('Warranty valid until:'),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                            '${formatDate(purchaseDate, [
                                  'dd',
                                  '-',
                                  'mm',
                                  '-',
                                  'yyyy'
                                ])} - ${formatDate(purchaseDate.add(Duration(days: int.parse(purchase.numPeriods!) * 365)), [
                                  'dd',
                                  '-',
                                  'mm',
                                  '-',
                                  'yyyy'
                                ])}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Serial Number:'),
                      SizedBox(width: 10),
                      Text(purchase.serialNo!),
                      // Expanded(
                      //   child: DropdownButton<String>(
                      //     items: productModel
                      //         .map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(
                      //           value,
                      //           overflow: TextOverflow.ellipsis,
                      //           maxLines: 2,
                      //         ),
                      //       );
                      //     }).toList(),
                      //     isExpanded: true,
                      //     value: chosenProductModel,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         chosenProductModel = value.toString();
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            //purchase date
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.5,
                    color: Colors.grey,
                    spreadRadius: 0.5,
                    // offset:
                  ),
                ],
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Purchase Date : '),
                      Text(formatDate(
                          purchaseDate, ['dd', '-', 'mm', '-', 'yyyy'])),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('New Extended Warranty'),
                  SizedBox(height: 5),
                  Text(
                    '${formatDate(now, [
                          'dd',
                          '-',
                          'mm',
                          '-',
                          'yyyy'
                        ])} - ${formatDate(now.add(Duration(days: 365)), [
                          'dd',
                          '-',
                          'mm',
                          '-',
                          'yyyy'
                        ])}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Text('Store : '),
                Text('KHIND Marketing SDN BHD'),
              ],
            ),

            SizedBox(height: 10),
            Text('Warranty Cost:-'),

            SizedBox(height: 10),

            Text('RM ${purchase.extendedEwarrantyCost ?? '95.00'}',
                style: TextStyle(fontWeight: FontWeight.bold)),

            // SizedBox(height: 50),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GradientButton(
                  height: 40,
                  child: Text(
                    "Apply",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.grey[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  onPressed: () async {
                    bool success = await Repositories.sendExtend(
                      warrantyId: purchase.warrantyRegistrationId,
                    );

                    if (success) {
                      Alert(
                        context: context,
                        // type: AlertType.info,
                        title: "Warranty Extension Submitted",
                        desc:
                            "You will be notified in 2 days on the approval of the extension. Please ensure that payment is done within 7 days after approval",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Okay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                              'home',
                              (route) => false,
                              arguments: 0,
                            ),
                            width: 120,
                          )
                        ],
                      ).show();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Something went wrong, please try again',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                ),
              ),
            ),

            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SizedBox(
            //       width: double.infinity,
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(primary: Colors.grey),
            //         onPressed: () {},
            //         child: Text('Apply'),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
