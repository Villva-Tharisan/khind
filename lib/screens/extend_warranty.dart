import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/util/helpers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ExtendWarranty extends StatefulWidget {
  const ExtendWarranty({Key? key}) : super(key: key);

  @override
  State<ExtendWarranty> createState() => _ExtendWarrantyState();
}

class _ExtendWarrantyState extends State<ExtendWarranty> {
  List<String> productModel = [
    'E000001',
    'E000002',
    'E000003',
  ];

  late String chosenProductModel;

  @override
  void initState() {
    chosenProductModel = productModel[0];
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                  Text('AIR COND'),
                  Text('AC105l(1HP A.COND+IONIZER-I/D)'),
                  SizedBox(height: 30),
                  Text('Warranty Period : 12-12-2020 12-12-2021'),
                  Row(
                    children: [
                      Text('Serial Number: '),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          items: productModel
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            );
                          }).toList(),
                          isExpanded: true,
                          value: chosenProductModel,
                          onChanged: (value) {
                            setState(() {
                              chosenProductModel = value.toString();
                            });
                          },
                        ),
                      ),
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
                      Text('10-12-2020'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Store : '),
                      Text('KHIND Marketing SDN BHD'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Text('New Extended Warranty'),
            SizedBox(height: 10),

            Text('12-12-2021 12-12-22'),
            SizedBox(height: 10),

            Text('Warranty Cost:-'),
            SizedBox(height: 10),

            Text('RM 15.00'),

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
                  onPressed: () {
                    Alert(
                      context: context,
                      // type: AlertType.info,
                      title: "Warranty Extension Submitted",
                      desc:
                          "The result will be notified within 7 days. Payment need to be made after 7 days for approval.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Okay",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
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
