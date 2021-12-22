import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/states.dart';
import 'dart:convert';

import 'package:khind/services/api.dart';

class ServiceLocator extends StatefulWidget {
  const ServiceLocator({Key? key}) : super(key: key);

  @override
  _ServiceLocatorState createState() => _ServiceLocatorState();
}

class _ServiceLocatorState extends State<ServiceLocator> {
  List<String> states = [
    'Selangor',
    'Perak',
  ];

  List<States> _states = [];

  List<String> cities = [
    'Kuala Lumpur',
    'Shah Alam',
    'Ipoh',
  ];

  late String state;
  late String city;

  @override
  void initState() {
    state = states[0];
    city = cities[0];
    super.initState();
    this.fetchStates();
  }

  Future<void> fetchStates() async {
    var url = Uri.parse(Api.endpoint + Api.GET_STATES);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };
    final response = await http.get(
      url,
      headers: authHeader,
    );

    print("aa");

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      var states =
          (resp['states'] as List).map((i) => States.fromJson(i)).toList();

      setState(() {
        _states = states;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Locate a Service Center'),
      ),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    width: width * 0.45,
                    child: DropdownButton<String>(
                      items: _states.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          child: Text(
                            e.state!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          value: e.stateId!,
                        );
                      }).toList(),
                      isExpanded: true,
                      // value: state,
                      onChanged: (value) {
                        this.fetchStates();
                        setState(() {
                          state = value.toString();
                        });
                      },
                    ),
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
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    width: width * 0.45,
                    child: DropdownButton<String>(
                      items:
                          cities.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                      value: city,
                      onChanged: (value) {
                        setState(() {
                          city = value.toString();
                        });
                      },
                    ),
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
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 130,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
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
                    "Khind Marketing (M) SDN BHD",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      // height: 2,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'No 2, Jalan Astaka U8/82, Bukit Jelutong, 40150 Shah Alam,  Selangor',
                    style:
                        TextStyle(height: 1, fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Operating Hours:",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          // height: 2,
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text("8:30 AM - 6:00 PM Mon-Sun",
                            style: TextStyle(
                                height: 1, fontSize: 14, color: Colors.black)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Contact:",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          // height: 2,
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text("6096314175",
                            style: TextStyle(
                                height: 1, fontSize: 14, color: Colors.black)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
