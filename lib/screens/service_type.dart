import 'package:flutter/material.dart';
import 'package:khind/util/helpers.dart';

class ServiceType extends StatefulWidget {
  @override
  _ServiceTypeState createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String isChecked = "";
  List<String> _serviceTypes = [
    'Home Visit',
    'Drop By',
    'Request for pickup service RM 95.00',
  ];

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tell us what type of service you require'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'For 1.0L RICE COOKER product',
                    style: TextStyle(
                        // height: 2,
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
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
                            value: isChecked == e ? true : false,
                            onChanged: (value) {
                              setState(() {
                                isChecked = e;
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
          ],
        ),
      ),
    );
  }
}
