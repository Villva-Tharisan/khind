import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    var formattedDate =
        DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(widget.data!.purchaseDate!));

    setState(() {
      purchase = widget.data;
      serialNoCT.text = widget.data != null && widget.data?.serialNo != null
          ? widget.data!.serialNo.toString()
          : "";
      purchaseDate = formattedDate;
    });
    super.initState();
  }

  @override
  void dispose() {
    serialNoCT.clear();
    super.dispose();
  }

  void _handleCreateSerialNo() async {
    var queryParams =
        '?email=khindcustomerservice@gmail.com&warranty_registration_id=${purchase!.warrantyRegistrationId}&serial_no=${serialNoCT.text}';

    final response =
        await Api.bearerPost('provider/create_serial_number.php$queryParams', isCms: true);

    if (response['success']) {
      setState(() {
        purchase!.serialNo = serialNoCT.text;
      });

      Helpers.showAlert(context,
          title: 'You have successfully updated serial number', hasAction: true, onPressed: () {
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, 'home');
      });
    }
  }

  void _handleDeletePurchase() async {
    var queryParams = "?warranty_registration_id=${purchase!.warrantyRegistrationId}";
    final response = await Api.bearerPost('provider/rm_my_purchase.php$queryParams', isCms: true);
    if (response['success']) {
      Helpers.showAlert(context,
          title: 'You have successfully remove this purchase', hasAction: true, onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        purchase!.productModel!,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            // height: 2,
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(widget.data!.productDescription!),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Warranty Valid until: ${purchase!.warrantyPeriod}",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            // height: 2,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
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
                      Text("Purchase Date: ${purchaseDate!}"),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Warranty Period: ${purchase!.warrantyPeriod}",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            // height: 2,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
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
                      Text(
                        "Serial Number",
                      ),
                      Form(
                        key: _basicFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter serial number';
                                  }
                                  return null;
                                },
                                controller: serialNoCT,
                                onFieldSubmitted: (val) {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                },
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: 'eg: AP550XXXXXMLKD',
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RoundButton(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 40,
                              title: "Save",
                              onPressed: () {
                                if (_basicFormKey.currentState!.validate()) {
                                  _handleCreateSerialNo();
                                }
                              }),
                          // Container(
                          //   child: MaterialButton(
                          //     child: Text(
                          //       'Save',
                          //       // style: TextStyle(fontSize: 20.0),
                          //     ),
                          //     color: Colors.grey.withOpacity(0.3),
                          //     textColor: Colors.black,
                          //     onPressed: () {
                          //       if (_basicFormKey.currentState!.validate()) {
                          //         _handleCreateSerialNo();
                          //       }
                          //     },
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GradientButton(
                        height: 40,
                        child: Text(
                          "Request Repair",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        gradient: LinearGradient(
                            colors: <Color>[Colors.white, Colors.grey[400]!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        onPressed: () {
                          Navigator.pushNamed(context, 'serviceType',
                              arguments: purchase != null ? purchase : null);
                        },
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

                      if (Helpers.purchase!.statusCode != '2')
                        GradientButton(
                          height: 40,
                          child: Text(
                            "Extend Warranty",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          gradient: LinearGradient(
                              colors: <Color>[Colors.white, Colors.grey[400]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          onPressed: () {
                            Navigator.of(context).pushNamed('ExtendWarranty');
                          },
                        ),

                      if (Helpers.purchase!.statusCode == '2')
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
                              child: GradientButton(
                                height: 40,
                                child: Text(
                                  "I dont have this anymore",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                gradient: LinearGradient(
                                    colors: <Color>[Colors.white, Colors.grey[400]!],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
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
