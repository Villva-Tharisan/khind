import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/models/Purchase.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/user.dart';
import 'package:khind/util/api.dart';
import 'dart:convert';

import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class MyPurchases extends StatefulWidget {
  const MyPurchases({Key? key}) : super(key: key);

  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

class _MyPurchasesState extends State<MyPurchases> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  final storage = new FlutterSecureStorage();
  static const PAGE_LIMIT = 20;
  bool _hasMore = false;
  int _page = 1;
  bool _fetchError = false;
  List<String> _status = [
    'All',
    'Active',
    'Expired',
    'Nearing Expiry',
  ];

  String selectedStatus = "All";

  List<Purchase> _myPurchase = [];
  List<Purchase> _filteredMyPurchase = [];
  User? user;
  @override
  void initState() {
    super.initState();
    this._loadUser();
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

  _loadUser() async {
    var userStorage = await storage.read(key: USER);

    if (userStorage != null) {
      User userJson = User.fromJson(jsonDecode(userStorage));

      setState(() {
        user = userJson;
      });

      this.fetchMyPurchases();
      // print("###USER: ${jsonEncode(user)}");
    }
  }

  Future<void> fetchMyPurchases({bool isRefresh = false}) async {
    // :TODO get email from storage
    // var url = Uri.parse(Api.endpoint + Api.GET_MY_PURCHASE + "?email=$email");
    // Map<String, String> authHeader = {
    //   'Content-Type': 'application/json',
    //   'Authorization': Api.defaultToken,
    // };
    // final response = await http.post(
    //   url,
    //   headers: authHeader,
    // );

    if (isRefresh) {
      setState(() {
        _page = 1;
        _myPurchase = [];
        _filteredMyPurchase = [];
        _fetchError = false;
      });
    }

    final response = await Api.basicPost(
        'provider/purchase.php?email=${user!.email!.toLowerCase()}&currentpage=$_page',
        isCms: true);

    var page = _page;

    var purchases =
        (response['data'] as List).map((i) => Purchase.fromJson(i)).toList();

    if (purchases.length < PAGE_LIMIT) {
      setState(() {
        _fetchError = true;
      });
    } else {
      setState(() {
        _fetchError = false;
      });
    }

    var allPurchase = _myPurchase;
    allPurchase.addAll(purchases);
    var filteredPurchase = allPurchase;
    if (selectedStatus != "All") {
      filteredPurchase = filteredPurchase
          .where((element) => element.status! == selectedStatus)
          .toList();
    }

    setState(() {
      _myPurchase = allPurchase;
      _filteredMyPurchase = filteredPurchase;
      _hasMore = purchases.length == PAGE_LIMIT;
      _page += 1;
    });
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
        // height: double.infinity,
        // padding: const EdgeInsets.symmetric(
        //   vertical: 20,
        //   horizontal: 0,
        // ),
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
                        padding: EdgeInsets.only(right: 10),
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
                    // color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: height * 0.75,
                    child: _myPurchase.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  "No more data to show, tap to refresh",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          )
                        : RefreshIndicator(
                            key: _refreshKey,
                            onRefresh: () {
                              return fetchMyPurchases(isRefresh: true);
                            },
                            child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // shrinkWrap: false,
                              itemCount: _filteredMyPurchase.length +
                                  (_hasMore ? 1 : 0),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == _filteredMyPurchase.length - 1) {
                                  fetchMyPurchases();
                                }
                                if (index == _filteredMyPurchase.length) {
                                  if (_fetchError) {
                                    return Center(
                                        child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _fetchError = false;
                                          fetchMyPurchases();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                            "Error while loading photos, tap to try agin"),
                                      ),
                                    ));
                                  } else {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: CircularProgressIndicator(),
                                    ));
                                  }
                                }
                                return PurchaseItem(
                                  width: width,
                                  purchase: _filteredMyPurchase[index],
                                );
                              },
                            ),
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
        // Navigator.pushNamed(
        //   context,
        //   'productModel',
        // );
        Helpers.purchase = purchase;
        Navigator.pushNamed(context, 'productModel',
            arguments: purchase != null ? purchase : null);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 0.1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Serial No : ${purchase.serialNo}",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Warranty Status : ",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            // height: 2,
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "${purchase.status}",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            // height: 2,
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Column(children: [
              Container(
                width: width * 0.06,
                height: 100,
                padding: EdgeInsets.only(right: 1),
                decoration: BoxDecoration(
                  color: getColor(),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 12,
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
