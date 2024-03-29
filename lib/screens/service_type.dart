import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/request_service_arguments.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';

class ServiceType extends StatefulWidget {
  Purchase? data;
  ServiceType({this.data});

  @override
  _ServiceTypeState createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();
  Purchase? purchase;
  String _selectedType = "";
  List<String> _serviceTypes = [
    'Home Visit',
    'Drop-In',
    'Pick Up',
  ];

  bool isValid = false;
  bool showError = false;

  @override
  void initState() {
    // TODO: implement initState
    var formattedDate =
        DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(widget.data!.purchaseDate!));

    if (widget.data!.dropIn == "0") {
      _serviceTypes.remove('Drop-In');
    }
    if (widget.data!.homeVisit == "0") {
      _serviceTypes.remove('Home Visit');
    }
    if (widget.data!.pickUp == "0") {
      _serviceTypes.remove('Pick Up');
    }

    setState(() {
      purchase = widget.data;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.black;
    }

    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Service Type", hasActions: false, isBack: true, isPrimary: true),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderBody(getColor, context),
        )
      ]),
    );
  }

  Container _renderBody(Color getColor(Set<MaterialState> states), BuildContext context) {
    TextStyle noteStyle = TextStyles.textJeanBlue;

    List<Widget> getDescription() {
      if (_selectedType == "Drop-In") {
        return [
          Text('* Drop In :-', style: noteStyle.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text('- Only applicable for Khind Service Center (10 Branches)', style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text(
              '- Drop in service only available based on the selected Khind service center operating hours',
              style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text('- Authorized Service Contractors are excluded at the moment', style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text(
              '- Courier fee of RM 15.00 will be charged if delivery service after repair is needed',
              style: noteStyle),
          SizedBox(
            height: 10,
          ),
        ];
      }
      if (_selectedType == "Home Visit") {
        return [
          Text('* Home Visit :-', style: noteStyle.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text('- Only limited to Klang Valley at the moment', style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text('- Limited to Major Domestic Appliances', style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text('- Booking of 2 days in advance is needed for the home visit service',
              style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text(
              '- Home visit service only available based on the selected Khind service center operating hours',
              style: noteStyle),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 10,
          ),
        ];
      }
      if (_selectedType == "Pick Up") {
        return [
          Text('* Pick Up :-', style: noteStyle.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text('- Only limited to Klang Valley at the moment', style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text(
              '- Courier fee of RM 15.00 will be charge for defect item pick-up for repair. Additional RM 15.00 will be charge if if delivery service after repair is needed',
              style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text('- Booking of 2 days in advance is needed for the pick-up service',
              style: noteStyle),
          SizedBox(
            height: 5,
          ),
          Text('- Pick-up service will be handled by Khind nominated courier partner',
              style: noteStyle),
        ];
      }
      return [Container()];
    }

    var productDescription = "-";

    if (purchase!.productDescription! != null) {
      productDescription = purchase!.productDescription!;
    }

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
          SizedBox(
            height: 20,
          ),
          Container(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Which type of service would you prefer?',
                      style: TextStyles.textDefaultBoldMd),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    productDescription,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ..._serviceTypes
                    .map((e) => new Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: _selectedType == e ? AppColors.primary : Colors.white,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e),
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: _selectedType == e ? true : false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = e;
                                  });
                                },
                              ),
                            ],
                          ),
                        ))
                    .toList()
              ])),
          SizedBox(
            height: 20,
          ),
          !showError
              ? Container()
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '*Please choose service type',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...getDescription(),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showError
                        ? Center(
                            child: Text('* Please select service required above',
                                style: TextStyles.textWarningBold))
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                      title: 'Next',
                      onPressed: () async {
                        setState(() {
                          showError = false;
                        });
                        if (_selectedType.isEmpty) {
                          setState(() {
                            showError = true;
                          });

                          return;
                        }
                        String type = "";
                        var path = 'requestDateHomeVisit';
                        if (_selectedType == "Drop-In") {
                          type = "Drop-In";
                          path = "requestDateDropIn";
                        }
                        if (_selectedType.contains("Pick Up")) {
                          type = "Pick Up";
                          path = "requestDatePickup";
                        }
                        await storage.write(key: "SERVICE_TYPE", value: type);
                        Navigator.pushNamed(context, path,
                            arguments: purchase != null ? purchase : null);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
