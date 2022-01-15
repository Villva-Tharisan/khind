import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/service_problem.dart';
import 'package:khind/models/states.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/states.dart';
import 'dart:convert';

class RequestDateDropIn extends StatefulWidget {
  @override
  _RequestDateDropInState createState() => _RequestDateDropInState();
}

class _RequestDateDropInState extends State<RequestDateDropIn> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _times = ["8am", "10am", "2pm", "4pm"];
  List<States> _states = [];
  List<ServiceProblem> _problems = [];
  late States state;
  late ServiceProblem _problem;
  @override
  void initState() {
    state = new States(
        countryId: "", state: "--Select--", stateId: "", stateCode: "");

    super.initState();
    this.fetchStates();
    this.fetchProblems();
  }

  Future<void> fetchStates() async {
    final response = await Api.bearerGet('provider/state.php', isCms: true);

    var states =
        (response['states'] as List).map((i) => States.fromJson(i)).toList();

    states.insert(
        0,
        new States(
            countryId: "", state: "--Select--", stateId: "", stateCode: ""));

    setState(() {
      _states = states;
      state = states[0];
    });
  }

  Future<void> fetchProblems() async {
    final response = await Api.bearerGet('provider/problems.php', isCms: true);

    var problems = (response['data'] as List)
        .map((i) => ServiceProblem.fromJson(i))
        .toList();

    setState(() {
      _problems = problems;
      _problem = problems[0];
    });
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
              height: 5,
            ),
            Text(
              'Select Date & Time',
              style: TextStyle(
                // height: 2,
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: SfDateRangePicker(
                // onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
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
            SizedBox(
              height: 10,
            ),
            Text(
              'Selected Service Center',
            ),
            SizedBox(
              height: 10,
            ),
            //service centre
            Container(
              width: double.infinity,
              // height: 140,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Khind Marketing (M) SDN BHD",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      // height: 2,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Address line 1",
                    style:
                        TextStyle(height: 1, fontSize: 12, color: Colors.black),
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
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text("1-800-88-0032",
                            style: TextStyle(
                                height: 1, fontSize: 12, color: Colors.black)),
                      )
                    ],
                  )
                ],
              ),
            ),
            //endof service centre
            SizedBox(
              height: 10,
            ),
            Text(
              'What are problems are you facing with your product?',
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              // height: 140,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Problem:",
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          // height: 2,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          width: width * 0.45,
                          child: DropdownButton<ServiceProblem>(
                            items: _problems
                                .map<DropdownMenuItem<ServiceProblem>>((e) {
                              return DropdownMenuItem<ServiceProblem>(
                                child: Text(
                                  e.problem!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                value: e,
                              );
                            }).toList(),
                            isExpanded: true,
                            value: _problem,
                            onChanged: (value) {
                              setState(() {
                                _problem = value!;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  )
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
