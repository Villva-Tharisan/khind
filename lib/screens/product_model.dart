import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
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
    var formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(widget.data!.purchaseDate!));
    setState(() {
      purchase = widget.data;
      serialNoCT.text = widget.data!.serialNo!;
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

    final response = await Api.bearerPost(
        'provider/create_serial_number.php$queryParams',
        isCms: true);

    if (response['success']) {
      setState(() {
        purchase!.serialNo = serialNoCT.text;
      });

      Helpers.showAlert(context,
          title: 'You have successfully updated serial number',
          hasAction: true, onPressed: () {
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, 'home');
      });
    }
  }

  void _handleDeletePurchase() async {
    var queryParams =
        "?warranty_registration_id=${purchase!.warrantyRegistrationId}";
    final response = await Api.bearerPost(
        'provider/rm_my_purchase.php$queryParams',
        isCms: true);
    if (response['success']) {
      Helpers.showAlert(context,
          title: 'You have successfully remove this purchase',
          hasAction: true, onPressed: () {
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
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
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
                  padding: EdgeInsets.all(15),
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
                      Text("Purchase Date: ${purchaseDate!}"),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Store: ${purchase!.storeName}",
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
                      BoxShadow(
                        blurRadius: 0.5,
                        color: Colors.grey,
                        spreadRadius: 0.5,
                        // offset:
                      ),
                    ],
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fill in the product serial number"),
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
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'eg: AP550XXXXXMLKD',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 5),
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: FlatButton(
                                child: Text(
                                  'Save',
                                  // style: TextStyle(fontSize: 20.0),
                                ),
                                color: Colors.grey.withOpacity(0.3),
                                textColor: Colors.black,
                                onPressed: () {
                                  if (_basicFormKey.currentState!.validate()) {
                                    _handleCreateSerialNo();
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
                      Container(
                        child: FlatButton(
                          child: Text(
                            'Request Repair',
                            // style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.grey.withOpacity(0.3),
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.pushNamed(context, 'serviceType',
                                arguments: purchase != null ? purchase : null);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: FlatButton(
                          child: Text(
                            'Extend Warranty',
                            // style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.grey.withOpacity(0.3),
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pushNamed('ExtendWarranty');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      purchase!.iDontHaveThisAnymore!.isEmpty
                          ? Container()
                          : Container(
                              width: 128,
                              child: FlatButton(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                child: Text(
                                  'I dont have this anymore',
                                  textAlign: TextAlign.center,
                                  // style: TextStyle(fontSize: 20.0),
                                ),
                                color: Colors.grey.withOpacity(0.3),
                                textColor: Colors.black,
                                onPressed: () {
                                  Helpers.showAlert(
                                    context,
                                    okTitle: "Yes",
                                    noTitle: "No",
                                    // title: "Sign out confirmation",
                                    desc:
                                        "Do you want to remove this product from 'My Purchase'",
                                    hasAction: true,
                                    hasCancel: true,
                                    onPressed: () async {
                                      _handleDeletePurchase();
                                    },
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
