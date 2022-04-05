import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/models/Purchase.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/user.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
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
  bool _isRefresh = false;
  List<String> _status = [
    'All',
    'In Warranty',
    'Out of Warranty',
    'Warranty Expiring',
  ];

  // List<String> _status = [
  //   'In warranty',
  //   'Warranty Expiring',
  //   'Out of Warranty',
  // ];

  String selectedStatus = "All";

  List<Purchase> _myPurchase = [];
  List<Purchase> _filteredMyPurchase = [];
  User? user;
  @override
  void initState() {
    super.initState();
    this._loadUser();
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

  void onSelectStatus(String status) {
    List<Purchase> filter;
    if (status == "All") {
      filter = _myPurchase;
    } else {
      filter = _myPurchase.where((element) => element.status == status).toList();
    }

    setState(() {
      _filteredMyPurchase = filter;
      _fetchError = filter.isEmpty ? true : false;
    });
  }

  Future<void> fetchMyPurchases({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _page = 1;
        _myPurchase = [];
        _filteredMyPurchase = [];
        _fetchError = false;
        _isRefresh = true;
      });
    }

    // print("#SELECTEDSTATUS: $selectedStatus");

    final response = await Api.basicPost(
        'provider/purchase.php?email=${user!.email!.toLowerCase()}&currentpage=$_page&warranty_status=${selectedStatus}',
        isCms: true);

    var page = _page;

    if (response['data'] != null) {
      var purchases = (response['data'] as List).map((i) => Purchase.fromJson(i)).toList();

      if (purchases.length < PAGE_LIMIT) {
        setState(() {
          _fetchError = true;
        });
      } else {
        setState(() {
          _fetchError = false;
        });
      }

      purchases.sort((a, b) {
        return a.statusCode!.compareTo(b.statusCode!);
      });

      var allPurchase = _myPurchase;
      allPurchase.addAll(purchases);
      var filteredPurchase = allPurchase;
      if (selectedStatus != "All") {
        filteredPurchase =
            filteredPurchase.where((element) => element.status! == selectedStatus).toList();
      }

      setState(() {
        _myPurchase = allPurchase;
        _filteredMyPurchase = filteredPurchase;
        _hasMore = purchases.length == PAGE_LIMIT;
        _isRefresh = false;
        _page += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey, title: "My Purchases", isPrimary: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
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
                            setState(() {
                              selectedStatus = value!;
                            });
                            this.fetchMyPurchases(isRefresh: true);
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
                    child: _myPurchase.isEmpty && !_isRefresh
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("There's no purchase record",
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
                              itemCount: _filteredMyPurchase.length + (_hasMore ? 1 : 0),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == _filteredMyPurchase.length) {
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
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Text("There's no purchase record",
                                                    style: TextStyle(color: Colors.black)),
                                              ),
                                            )));
                                  } else {
                                    if (_isRefresh) {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    } else if (!_isRefresh && _myPurchase.isEmpty) {
                                      return Container();
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    }
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
    if (this.purchase.statusCode == "2") return Colors.red;
    if (this.purchase.statusCode == "0") return Colors.green;

    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    var serialNo = this.purchase.serialNo == null ? "" : this.purchase.serialNo;
    return GestureDetector(
      onTap: () async {
        // Navigator.pushNamed(
        //   context,
        //   'productModel',
        // );
        Helpers.purchase = purchase;
        Helpers.productWarranty = productWarrantyFromJson(
            await Repositories.getProduct(productModel: purchase.productModel!));

        // print("#PURCHASE: ${jsonEncode(purchase)}");
        Navigator.pushNamed(context, 'productModel', arguments: purchase != null ? purchase : null);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 0.1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
          ],
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.productGroupDescription!,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    Text(
                      purchase.productModel!,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          // height: 2,
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("|", style: TextStyle(color: Colors.grey)),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      purchase.modelDescription!,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          // height: 2,
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    )
                  ]),
                  SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    // CustomCard(label: "Serial No"),
                    Text(
                      "Serial No. :",
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          // height: 2,
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(width: 2),
                    // Text(
                    //   serialNo!,
                    //   overflow: TextOverflow.visible,
                    //   style: TextStyle(
                    //       // height: 2,
                    //       fontSize: 12,
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.w400),
                    // )
                    serialNo != null && serialNo != ""
                        ? CustomCard(
                            borderRadius: BorderRadius.circular(5),
                            label: serialNo,
                            textStyle: TextStyles.textDefaultBold.copyWith(fontSize: 10),
                            color: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5))
                        : Text("-"),
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Text(
                      "Purchase Date :",
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          // height: 2,
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(width: 2),
                    CustomCard(
                        borderRadius: BorderRadius.circular(5),
                        label: purchase.purchaseDateFormat,
                        textStyle: TextStyles.textDefaultBold.copyWith(fontSize: 10),
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5)),
                  ]),
                  SizedBox(
                    height: 5,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Warranty Valid until : ",
                  //       overflow: TextOverflow.visible,
                  //       style: TextStyle(
                  //           fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
                  //     ),
                  //     CustomCard(
                  //         borderRadius: BorderRadius.circular(5),
                  //         label: purchase.warrantyDate,
                  //         textStyle: TextStyles.textDefaultBold.copyWith(fontSize: 10),
                  //         color: Colors.grey[200],
                  //         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5))
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Row(children: [
                    Text(
                      "Warranty valid until : ",
                      overflow: TextOverflow.visible,
                      style:
                          TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    CustomCard(
                        borderRadius: BorderRadius.circular(5),
                        label: purchase.warrantyDate,
                        textStyle: TextStyles.textDefaultBold.copyWith(fontSize: 10),
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5))
                  ]),
                  SizedBox(height: 5),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Text("|", style: TextStyle(color: Colors.grey)),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Row(children: [
                  //   Text(
                  //     "Frequency of Repair : ",
                  //     overflow: TextOverflow.visible,
                  //     style: TextStyle(
                  //         fontSize: 12,
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.w400),
                  //   ),
                  //   CustomCard(
                  //       label: "1",
                  //       color: Colors.yellow[800],
                  //       width: 20,
                  //       height: 20),
                  //   SizedBox(width: 5),
                  // ]),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Column(children: [
              Container(
                width: width * 0.06,
                height: 150,
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
