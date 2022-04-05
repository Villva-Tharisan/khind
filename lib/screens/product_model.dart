import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/user.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

import '../models/store.dart';

class ProductModel extends StatefulWidget {
  Purchase? data;
  ProductModel({this.data});

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _basicFormKey = GlobalKey<FormState>();
  Purchase? purchase;
  TextEditingController serialNoCT = new TextEditingController();
  String? purchaseDate = "";
  String? _storeName = "-";
  bool canRequestRepair = true;
  @override
  void initState() {
    // TODO: implement initState
    var formattedDate =
        DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(widget.data!.purchaseDate!));

    setState(() {
      purchase = widget.data;
      serialNoCT.text = widget.data != null && widget.data?.serialNo != null
          ? widget.data!.serialNo.toString()
          : "-";
      purchaseDate = formattedDate;
    });

    if (purchase!.dropIn == '0' && purchase!.homeVisit == '0' && purchase!.pickUp == '0') {
      setState(() {
        canRequestRepair = false;
      });
    }

    this.getStore();

    super.initState();
  }

  @override
  void dispose() {
    serialNoCT.clear();
    super.dispose();
  }

  void _handleCreateSerialNo() async {
    var userStorage = await storage.read(key: USER);
    User userJson = User.fromJson(jsonDecode(userStorage!));
    var email = userJson.email?.toLowerCase();
    var queryParams =
        '?email=$email&warranty_registration_id=${purchase!.warrantyRegistrationId}&serial_no=${serialNoCT.text}';

    final response =
        await Api.bearerPost('provider/create_serial_number.php$queryParams', isCms: true);

    if (response['success']) {
      setState(() {
        purchase!.serialNo = serialNoCT.text;
      });

      Helpers.showAlert(context,
          title: 'You have successfully updated serial number', hasAction: true, onPressed: () {
        Navigator.pop(context);
      });
    }
  }

  void _handleDeletePurchase() async {
    var queryParams = "?warranty_registration_id=${purchase!.warrantyRegistrationId}";

    // if (purchase?.iDontHaveThisAnymore)
    final response = await Api.bearerPost('provider/rm_my_purchase.php$queryParams', isCms: true);
    if (response['success']) {
      Helpers.showAlert(context,
          title: 'You have successfully removed this purchase', hasAction: true, onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home', arguments: 2);
      });
    }
  }

  Future<void> getStore() async {
    // final queryParameters = {
    //   'email': 'khindcustomerservice@gmail.com',
    // };

    // String queryString = Uri(queryParameters: queryParameters).query;

    final response = await Api.bearerGet('provider/store.php', isCms: true);
    var stores = (response['data'] as List).map((i) => Datum.fromJson(i)).toList();

    if (purchase!.storeName != null) {
      var storeName = stores.where((element) => element.storeId == purchase!.storeName);

      if (storeName.length > 0) {
        setState(() {
          _storeName = storeName.first.storeName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // var storeId = '-';
    var storeName = '-';
    if (purchase!.storeName != null) {
      storeName = purchase!.storeName;
    }

    var productGroupDesc = "-";
    if (purchase!.productGroupDescription != null) {
      productGroupDesc = purchase!.productGroupDescription!;
    }
    var productModel = "-";
    if (widget.data!.productModel! != null) {
      productModel = widget.data!.productModel!;
    }

    var modelDesc = "-";
    if (widget.data!.modelDescription! != null) {
      modelDesc = widget.data!.modelDescription!;
    }

    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Product Model", hasActions: false, isBack: true),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                    ],
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productGroupDesc,
                        overflow: TextOverflow.visible,
                        style: TextStyles.textDefaultBold,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(productModel),
                      SizedBox(
                        height: 5,
                      ),
                      Text(modelDesc),
                      // SizedBox(
                      //   height: 13,
                      // ),
                      // Text(
                      //   "Warranty Valid until: ${purchase!.warrantyPeriod}",
                      //   overflow: TextOverflow.visible,
                      //   style: TextStyle(
                      //       // height: 2,
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w400),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                    ],
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text("Purchase From :", style: TextStyles.textDefault),
                        SizedBox(width: 5),
                        Text(_storeName!, style: TextStyles.textDefaultBold)
                      ]),
                      // Text("Purchase From: $storeId"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Text("Purchase Date :", style: TextStyles.textDefault),
                        SizedBox(width: 5),
                        purchaseDate != "" && purchaseDate != "-"
                            ? Text(purchaseDate!, style: TextStyles.textDefaultBold)
                            : Text("-")
                      ]),
                      // Text("Purchase Date: ${purchaseDate!}"),
                      SizedBox(
                        height: 10,
                      ),
                      purchase?.warrantyPeriod != null
                          ? Row(children: [
                              Text("Warranty Valid until :", style: TextStyles.textDefault),
                              SizedBox(width: 5),
                              Text('${purchase?.warrantyDate}', style: TextStyles.textDefaultBold),
                              // CustomCard(
                              //     borderRadius: BorderRadius.circular(5),
                              //     label: purchase?.warrantyDate,
                              //     textStyle: TextStyles.textDefaultBold,
                              //     color: Colors.grey[200],
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 2, horizontal: 5)),
                              SizedBox(width: 5),
                            ])
                          // ? Text(
                          //     "Warranty Valid until: ${purchase?.warrantyPeriod}",
                          //     overflow: TextOverflow.visible,
                          //     style: TextStyle(
                          //         // height: 2,
                          //         fontSize: 13,
                          //         fontWeight: FontWeight.w400),
                          //   )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Text(
                          "Serial No. : ",
                          overflow: TextOverflow.visible,
                          style: TextStyles.textDefault,
                        ),
                        SizedBox(width: 2),
                        serialNoCT.text != "" && serialNoCT.text != "-"
                            ? CustomCard(
                                borderRadius: BorderRadius.circular(5),
                                label: serialNoCT.text,
                                textStyle: TextStyles.textDefaultBold,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5))
                            : Text("-"),
                      ]),
                    ],
                  ),
                ),
                // SizedBox(height: 10),
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.all(15),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                //     ],
                //     borderRadius: BorderRadius.circular(7.5),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(children: [
                //         Text(
                //           "Serial No. : ",
                //           overflow: TextOverflow.visible,
                //           style: TextStyles.textDefault,
                //         ),
                //         SizedBox(width: 2),
                //         serialNoCT.text != "" && serialNoCT.text != "-"
                //             ? CustomCard(
                //                 borderRadius: BorderRadius.circular(5),
                //                 label: serialNoCT.text,
                //                 textStyle: TextStyles.textDefaultBold,
                //                 color: Colors.grey[200],
                //                 padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5))
                //             : Text("-"),
                //       ]),
                //       // Text(
                //       //   "Serial Number: ${serialNoCT.text}",
                //       // ),
                //       // SizedBox(height: 20),
                //       // Row(
                //       //   mainAxisAlignment: MainAxisAlignment.end,
                //       //   children: [
                //       //   ],
                //       // )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      canRequestRepair
                          ? RoundButton(
                              title: 'Request Repair',
                              onPressed: () {
                                Navigator.pushNamed(context, 'serviceType',
                                    arguments: purchase != null ? purchase : null);
                              },
                            )
                          : GradientButton(
                              hideShadow: true,
                              height: 40,
                              child: Text(
                                "Request Repair",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              gradient: LinearGradient(
                                  colors: <Color>[Colors.grey[300]!, Colors.grey[300]!],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              onPressed: () {},
                            ),

                      // Container(
                      //   child: FlatButton(
                      //     child: Text(
                      //       'Request Repair',
                      //       // style: TextStyle(fontSize: 20.0),
                      //     ),
                      //     color: Colors.grey.withOpacity(0.3),
                      //     textColor: Colors.black,
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, 'serviceType',
                      //           arguments: purchase != null ? purchase : null);
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      // Text(
                      //     "TEST: ${purchase?.extendedEwarrantyCost} | ${Helpers.purchase!.statusCode}"),
                      // if (Helpers.purchase!.statusCode != '2' &&
                      //     purchase?.extendedEwarrantyCost == "0")
                      if (purchase?.extendedEwarrantyCost != "0" ||
                          purchase?.extendedEwarrantyCost != "null" ||
                          purchase?.extendedEwarrantyCost != null ||
                          purchase?.warranty!.substring(0, 1).toLowerCase() == 'E' ||
                          purchase?.warranty!.substring(0, 1).toLowerCase() == 'w00')
                        RoundButton(
                          title: 'Extend Warranty',
                          onPressed: () {
                            Navigator.of(context).pushNamed('ExtendWarranty');
                          },
                        )
                      else
                        GradientButton(
                          hideShadow: true,
                          height: 40,
                          child: Text(
                            "Extend Warranty",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          gradient: LinearGradient(
                              colors: <Color>[Colors.grey[300]!, Colors.grey[300]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          onPressed: () {},
                        ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: ElevatedButton(

                      //     style: ElevatedButton.styleFrom(primary: Colors.grey[300]),
                      //     onPressed: () {},
                      //     child: Text(
                      //       'Extend Warranty',
                      //       style: TextStyles.textWhite,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   child: FlatButton(
                      //     child: Text(
                      //       'Extend Warranty',
                      //       // style: TextStyle(fontSize: 20.0),
                      //     ),
                      //     color: Colors.grey.withOpacity(0.3),
                      //     textColor: Colors.black,
                      //     onPressed: () {
                      //       Navigator.of(context).pushNamed('ExtendWarranty');
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      purchase!.iDontHaveThisAnymore!.isEmpty
                          ? Container()
                          : Container(
                              // width: 128,
                              child: RoundButton(
                                title: "I dont't have this anymore",
                                onPressed: () {
                                  Helpers.showAlert(
                                    context,
                                    okTitle: "Yes",
                                    noTitle: "No",
                                    // title: "Sign out confirmation",
                                    desc: "Do you want to remove this product from 'My Purchase'",
                                    hasAction: true,
                                    hasCancel: true,
                                    onPressed: () async {
                                      _handleDeletePurchase();
                                    },
                                  );
                                },
                              ),
                              // child: RoundButton(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 40,
                              //     title: "I dont have this anymore",
                              //     color: Colors.red,
                              //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              //     onPressed: () {
                              //       Helpers.showAlert(
                              //         context,
                              //         okTitle: "Yes",
                              //         noTitle: "No",
                              //         // title: "Sign out confirmation",
                              //         desc: "Do you want to remove this product from 'My Purchase'",
                              //         hasAction: true,
                              //         hasCancel: true,
                              //         onPressed: () async {
                              //           _handleDeletePurchase();
                              //         },
                              //       );
                              //     }),
                              // child: FlatButton(
                              //   padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                              //   child: Text(
                              //     'I dont have this anymore',
                              //     textAlign: TextAlign.center,
                              //     // style: TextStyle(fontSize: 20.0),
                              //   ),
                              //   color: Colors.grey.withOpacity(0.3),
                              //   textColor: Colors.black,
                              //   onPressed: () {
                              //     Helpers.showAlert(
                              //       context,
                              //       okTitle: "Yes",
                              //       noTitle: "No",
                              //       // title: "Sign out confirmation",
                              //       desc: "Do you want to remove this product from 'My Purchase'",
                              //       hasAction: true,
                              //       hasCancel: true,
                              //       onPressed: () async {
                              //         _handleDeletePurchase();
                              //       },
                              //     );
                              //   },
                              // ),
                            ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
