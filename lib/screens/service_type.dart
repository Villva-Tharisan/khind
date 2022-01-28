import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/request_service_arguments.dart';
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
    var formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(widget.data!.purchaseDate!));

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
          title: "Service Type", hasActions: false, isBack: true),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderBody(getColor, context),
        )
      ]),
    );
  }

  Container _renderBody(
      Color getColor(Set<MaterialState> states), BuildContext context) {
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
                  Text('Tell us what type of service you require'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    purchase!.productDescription!,
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
          ..._serviceTypes
              .map((e) => new Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    padding:
                        EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
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
              .toList(),
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
                Text('*Drop In :-'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    '- Only applicable for Khind Service Center (10 Branches)'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Drop in service only available based on the selected Khind service center operating hours'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Authorized Service Contractors are excluded at the moment'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Courier fee of RM 15.00 will be charged if delivery service after repair is needed'),
                SizedBox(
                  height: 10,
                ),
                Text('*Home Visit :-'),
                SizedBox(
                  height: 10,
                ),
                Text('- Only limited to Klang Valley at the moment'),
                SizedBox(
                  height: 5,
                ),
                Text('- Limited to Major Domestic Appliances'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Booking of 2 days in advance is needed for the home visit service'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Home visit service only available based on the selected Khind service center operating hours'),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('*Pick Up :-'),
                SizedBox(
                  height: 10,
                ),
                Text('- Only limited to Klang Valley at the moment'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Courier fee of RM 15.00 will be charge for defect item pick-up for repair. Additional RM 15.00 will be charge if if delivery service after repair is needed'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Booking of 2 days in advance is needed for the pick-up service'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '- Pick-up service will be handled by Khind nominated courier partner'),
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
                            child: Text(
                                '* Please select service required above',
                                style: TextStyles.textWarningBold))
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    GradientButton(
                      height: 40,
                      child: Text(
                        "Next",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      gradient: LinearGradient(
                          colors: <Color>[Colors.white, Colors.grey[400]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      onPressed: () {
                        setState(() {
                          showError = false;
                        });
                        if (_selectedType.isEmpty) {
                          setState(() {
                            showError = true;
                          });

                          return;
                        }
                        var path = 'requestDateHomeVisit';
                        if (_selectedType == "Drop-In") {
                          path = "requestDateHomeVisit";
                        }
                        if (_selectedType.contains("Pick Up")) {
                          path = "requestDatePickup";
                        }

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
