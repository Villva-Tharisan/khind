import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/request_service_arguments.dart';
import 'package:khind/models/user.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class ReviewHomeVisit extends StatefulWidget {
  RequestServiceArgument? data;
  ReviewHomeVisit({this.data});

  @override
  _ReviewHomeVisitState createState() => _ReviewHomeVisitState();
}

class _ReviewHomeVisitState extends State<ReviewHomeVisit> {
  static final GlobalKey<FormState> _basicFormKey = GlobalKey<FormState>();
  TextEditingController remarkCT = new TextEditingController();
  late RequestServiceArgument _requestServiceArgument;
  String fullAddress = "";
  @override
  void initState() {
    // TODO: implement initState
    // var { } = _requestServiceArgument;

    _requestServiceArgument = widget.data!;
    fullAddress =
        "${_requestServiceArgument.address!.addressLine1!} ${_requestServiceArgument.address!.addressLine2!} ${_requestServiceArgument.address!.city!} ${_requestServiceArgument.address!.postcode!} ${_requestServiceArgument.address!.state!}";
    super.initState();
  }

  Future<void> createServiceRequest({bool isRefresh = false}) async {
    var userStorage = await storage.read(key: USER);
    User userJson = User.fromJson(jsonDecode(userStorage!));

    var payload = {
      "service_type": _requestServiceArgument.serviceType,
      "warranty_registration_id":
          _requestServiceArgument.purchase.warrantyRegistrationId,
      "product_id": _requestServiceArgument.purchase.productId,
      "problem_id": _requestServiceArgument.serviceProblem!.problemId,
      "user_id": _requestServiceArgument.purchase.userId,
      "service_request_date": _requestServiceArgument.serviceRequestDate,
      "remarks": _requestServiceArgument.remarks,
      "delivery_status": _requestServiceArgument.delivery == "Yes" ? 1 : 0,
      "service_request_time": _requestServiceArgument.serviceRequestTime,
      "address_line_1": _requestServiceArgument.address!.addressLine1,
      "address_line_2": _requestServiceArgument.address!.addressLine2,
      "city_id": _requestServiceArgument.address!.cityId,
      "postcode": _requestServiceArgument.address!.postcode,
    };

    var queryParams = "?";

    for (var key in payload.keys) {
      queryParams += "$key=${payload[key]}&";
    }

    queryParams = queryParams.substring(0, queryParams.length - 1);
    // print(queryParams);

    final response = await Api.basicPost(
        'provider/create_service_request.php$queryParams',
        isCms: true);

    if (response['success']) {
      Helpers.showAlert(context,
          title: 'You have successfully request service',
          hasAction: true, onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home', arguments: 2);
      });
    } else {
      Helpers.showAlert(context,
          title: 'Failed to request service', hasAction: true, onPressed: () {
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, 'home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Review", hasActions: false, isBack: true),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderBody(context),
        )
      ]),
    );
  }

  Container _renderBody(BuildContext context) {
    return Container(
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
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _requestServiceArgument.purchase.productModel!,
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
                Text(_requestServiceArgument.purchase.productDescription!),
                SizedBox(
                  height: 13,
                ),
                Text(
                  "Warranty Period: ${_requestServiceArgument.purchase.warrantyPeriod}",
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      // height: 2,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 13,
                ),
                Text(
                    "Serial No: ${_requestServiceArgument.purchase.serialNo!}"),
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
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Book Date'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(_requestServiceArgument.serviceRequestDate!),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Book Time Slot'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(_requestServiceArgument.serviceRequestTime!),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Service Type'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(_requestServiceArgument.serviceType!),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Problem'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(
                          _requestServiceArgument.serviceProblem!.problem!),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Address'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(fullAddress),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Remark'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(_requestServiceArgument.remarks!),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GradientButton(
                height: 40,
                child: Text(
                  "Confirm",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                gradient: LinearGradient(
                    colors: <Color>[Colors.white, Colors.grey[400]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                onPressed: () {
                  createServiceRequest();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
