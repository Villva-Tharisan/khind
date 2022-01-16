import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/request_service_arguments.dart';
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
  RequestServiceArgument? data;
  RequestDateDropIn({this.data});

  @override
  _RequestDateDropInState createState() => _RequestDateDropInState();
}

class _RequestDateDropInState extends State<RequestDateDropIn> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _timesSlot = ["AM", "PM"];
  String _selectedTimeSlot = "AM";
  String _selectedDate = '';
  List<States> _states = [];
  List<ServiceProblem> _problems = [];
  late States state;
  late ServiceProblem _problem;
  late RequestServiceArgument requestServiceArgument;
  @override
  void initState() {
    requestServiceArgument = widget.data!;
    state = new States(
        countryId: "", state: "--Select--", stateId: "", stateCode: "");
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderBody(context, width),
        )
      ]),
    );
  }

  Container _renderBody(BuildContext context, double width) {
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
              initialSelectedDate: DateTime.now(),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _selectedDate = DateFormat('yyyy-MM-dd').format(
                      DateFormat('yyyy-MM-dd hh:mm:ss')
                          .parse(args.value.toString()));
                });
              },
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
            'Select Time Slot',
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
                      "Time Slot:",
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
                        child: !_timesSlot.isEmpty
                            ? DropdownButton<String>(
                                items: _timesSlot
                                    .map<DropdownMenuItem<String>>((e) {
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
                                value: _selectedTimeSlot,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTimeSlot = value!;
                                  });
                                },
                              )
                            : Container(),
                      ),
                    )
                  ],
                )
              ],
            ),
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
                  requestServiceArgument.serviceCenter!.serviceCenterName!,
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
                  requestServiceArgument.serviceCenter!.address!,
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
                      child: Text(
                          requestServiceArgument.serviceCenter!.telephone!,
                          style: TextStyle(
                              height: 1, fontSize: 12, color: Colors.black)),
                    )
                  ],
                )
              ],
            ),
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
                        child: !_problems.isEmpty
                            ? DropdownButton<ServiceProblem>(
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
                              )
                            : Container(),
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
                  var requestServiceArgs = new RequestServiceArgument(
                      serviceProblem: _problem,
                      purchase: requestServiceArgument.purchase,
                      serviceCenter: requestServiceArgument.serviceCenter,
                      serviceRequestDate: _selectedDate,
                      serviceRequestTime: _selectedTimeSlot,
                      serviceType: 'Drop-In'
                      // serviceProblem: _problem
                      );

                  Navigator.pushNamed(
                    context,
                    'review',
                    arguments:
                        requestServiceArgs != null ? requestServiceArgs : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
