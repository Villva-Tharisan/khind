import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/states.dart';
import 'package:khind/services/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/states.dart';
import 'dart:convert';

class RequestDatePickup extends StatefulWidget {
  @override
  _RequestDatePickupState createState() => _RequestDatePickupState();
}

class _RequestDatePickupState extends State<RequestDatePickup> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _times = ["8am", "10am", "2pm", "4pm"];
  List<States> _states = [];
  late States state;
  @override
  void initState() {
    state = new States(
        countryId: "", state: "--Select--", stateId: "", stateCode: "");

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

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      var states =
          (resp['states'] as List).map((i) => States.fromJson(i)).toList();

      states.insert(
          0,
          new States(
              countryId: "", state: "--Select--", stateId: "", stateCode: ""));

      setState(() {
        _states = states;
        state = states[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Request Date", hasActions: false, isBack: true),
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
              height: 10,
            ),
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
                    "AIR FRYER",
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
                  Text("ARF3000 AIR FRYER 3L BK KD"),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    "Warranty Period: 12-12-2020 - 12-12-2021",
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
                    "Serial No: A12GHY90",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                    "Purchase Date: 10-12-2020",
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
                    "Store: KHIND Marketing SDN BHD",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Fill in your home address',
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.5,
                    color: Colors.grey,
                    spreadRadius: 0.5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        width: width * 0.30,
                        child: Text('Address Line 1'),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          // controller: emailCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: No 78 Jalan Mawar',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        width: width * 0.30,
                        child: Text('Address Line 2'),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          // controller: emailCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: Puchong Perdana',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        width: width * 0.30,
                        child: Text('City'),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          // controller: emailCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: No 78 Jalan Mawar',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        width: width * 0.30,
                        child: Text('Postcode'),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          // controller: emailCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: No 78 Jalan Mawar',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        width: width * 0.30,
                        child: Text('State'),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width * 0.45,
                        child: DropdownButton<States>(
                          items: _states.map<DropdownMenuItem<States>>((e) {
                            return DropdownMenuItem<States>(
                              child: Text(
                                e.state!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              value: e,
                            );
                          }).toList(),
                          isExpanded: true,
                          value: state,
                          onChanged: (value) {
                            setState(() {
                              state = value!;
                            });
                          },
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
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
                    'Request for pick up service RM XX.XX',
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
                    "Book",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.grey[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  onPressed: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   'requestServiceLocator',
                    // );
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
