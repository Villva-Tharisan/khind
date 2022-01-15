import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
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
    'Request for Pick-up/Delivery',
  ];

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
      _serviceTypes.remove('Request for Pick-up/Delivery');
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
                      padding: EdgeInsets.only(
                          left: 20, right: 15, top: 5, bottom: 5),
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
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('*Notes :-'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Request for pick up service only available around Klang Valley',
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
                    "Next",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.grey[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  onPressed: () {
                    //                   [
                    //   'Home Visit',
                    //   'Drop By',
                    //   'Request for pickup service RM 95.00',
                    // ];
                    if (_selectedType.isEmpty) return;
                    var path = 'requestDate';
                    if (_selectedType == "Drop-In") {
                      path = "requestServiceLocator";
                    }
                    if (_selectedType
                        .contains("Request for Pick-up/Delivery")) {
                      path = "requestDatePickup";
                    }
                    Navigator.pushNamed(
                      context,
                      path,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
