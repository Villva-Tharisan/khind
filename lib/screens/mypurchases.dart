import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:khind/util/helpers.dart';

class MyPurchases extends StatefulWidget {
  const MyPurchases({Key? key}) : super(key: key);

  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

class _MyPurchasesState extends State<MyPurchases> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _status = [
    'All',
    'Active',
    'Expired',
    'Nearing Expiry',
  ];

  String selectedStatus = "All";

  List<Purchase> _myPurchase = [];
  List<Purchase> _filteredMyPurchase = [];

  @override
  void initState() {
    super.initState();
    this.fetchMyPurchases();
  }

  void onSelectStatus(String status) {
    List<Purchase> filter;
    if (status == "All") {
      filter = _myPurchase;
    } else {
      filter =
          _myPurchase.where((element) => element.status == status).toList();
    }
    setState(() {
      _filteredMyPurchase = filter;
    });
  }

  Future<void> fetchMyPurchases() async {
    // :TODO get email from storage
    var email = "khindcustomerservice@gmail.com";
    var url = Uri.parse(Api.endpoint + Api.GET_MY_PURCHASE + "?email=$email");
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };
    final response = await http.post(
      url,
      headers: authHeader,
    );

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      var purchases =
          (resp['data'] as List).map((i) => Purchase.fromJson(i)).toList();

      setState(() {
        _myPurchase = purchases;
        _filteredMyPurchase = purchases;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "My Purchases", hasActions: false),
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
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   boxShadow: [
              //     BoxShadow(
              //       blurRadius: 0.5,
              //       color: Colors.grey,
              //       spreadRadius: 0.5,
              //       // offset:
              //     ),
              //   ],
              //   borderRadius: BorderRadius.circular(7.5),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: width * 0.5,
                        // height: 100,
                        child: DropdownButton<String>(
                          items: _status.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                e,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              value: e,
                            );
                          }).toList(),
                          isExpanded: true,
                          value: selectedStatus,
                          onChanged: (value) {
                            this.onSelectStatus(value!);
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: height * 0.65,
                    child: _myPurchase.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  "No more data to show, tap to refresh",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          )
                        : ListView.builder(
                            // shrinkWrap: false,
                            itemCount: _filteredMyPurchase.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PurchaseItem(
                                width: width,
                                purchase: _filteredMyPurchase[index],
                              );
                            },
                          ),
                  ),
                  // SizedBox(
                  //   height: height * 0.08,
                  // ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     height: 40,
                  //     width: width * 0.4,
                  //     padding: EdgeInsets.all(5),
                  //     decoration: BoxDecoration(
                  //       // color: Color(0xFFEFF0EF),
                  //       color: Colors.grey.withOpacity(0.3),
                  //       // borderRadius: BorderRadius.circular(7.5),
                  //     ),
                  //     child: Text('Out of Warranty but Request Repair'),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _scaffoldKey {}

class PurchaseItem extends StatelessWidget {
  const PurchaseItem({
    Key? key,
    required this.width,
    required this.purchase,
  }) : super(key: key);

  final double width;
  final Purchase purchase;

  Color getColor() {
    if (this.purchase.statusCode == "0") return Colors.red;
    if (this.purchase.statusCode == "1") return Colors.green;

    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          'productModel',
        );
      },
      child: Container(
        width: double.infinity,
        height: 80,
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.productModel!,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    purchase.productDescription!,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Expanded(child: Container()),
                  Text(
                    "Warranty Status : ${purchase.status}",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              width: width * 0.05,
              height: 80,
              padding: EdgeInsets.only(right: 1),
              decoration: BoxDecoration(
                color: getColor(),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.5,
                    color: Colors.grey,
                    spreadRadius: 0.5,
                    // offset:
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7.5),
                  bottomRight: Radius.circular(7.5),
                ),
              ),
              child: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
