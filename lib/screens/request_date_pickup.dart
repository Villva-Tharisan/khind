import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/address.dart';
import 'package:khind/models/city.dart';
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

class RequestDatePickup extends StatefulWidget {
  Purchase? data;
  RequestDatePickup({this.data});
  @override
  _RequestDatePickupState createState() => _RequestDatePickupState();
}

class _RequestDatePickupState extends State<RequestDatePickup> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  List<String> _times = ["8am", "10am", "2pm", "4pm"];
  List<States> _states = [];
  List<City> _cities = [];
  List<ServiceProblem> _problems = [];
  String _selectedDate = '';
  late States state;
  late Purchase purchase;
  late String postCode = "";
  late ServiceProblem _problem;
  TextEditingController postCodeCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  late City city;
  @override
  void initState() {
    // address1CT.text = 'address 1';
    // address2CT.text = 'address 2';
    state = new States(
        countryId: "", state: "--Select--", stateId: "", stateCode: "");
    city = new City(
      stateId: "",
      city: "--Select--",
      cityId: "",
      postcodeId: "",
      postcode: "",
    );

    _cities = [city];

    purchase = widget.data!;
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

  Future<void> fetchCities(String stateId) async {
    final response =
        await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var cities =
        (response['city'] as List).map((i) => City.fromJson(i)).toList();

    cities.insert(
        0,
        new City(
            stateId: "",
            city: "--Select--",
            cityId: "",
            postcodeId: "",
            postcode: ""));

    var citySet = Set<String>();
    List<City> newCities = cities.where((e) => citySet.add(e.city!)).toList();

    setState(() {
      _cities = newCities;
      city = newCities[0];
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

  void onSelectCity(String postCode) {
    setState(() {
      postCode = postCode;
      postCodeCT.text = postCode;
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
            height: 10,
          ),
          Text(
            'Select Date',
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
          Text(
            'Fill in your home address',
            style: TextStyle(
              // height: 2,
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
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
            child: Form(
              key: _addressFormKey,
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
                              return 'Please enter address 1';
                            }
                            return null;
                          },
                          controller: address1CT,
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
                              return 'Please enter address 2';
                            }
                            return null;
                          },
                          controller: address2CT,
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
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          width: width * 0.45,
                          child: DropdownButton<City>(
                            items: _cities.map<DropdownMenuItem<City>>((e) {
                              return DropdownMenuItem<City>(
                                child: Text(
                                  e.city!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                value: e,
                              );
                            }).toList(),
                            isExpanded: true,
                            value: city,
                            onChanged: (value) {
                              setState(() {
                                city = value!;
                                this.onSelectCity(value.postcode!);
                              });
                            },
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
                              return 'Please enter postcode';
                            }
                            return null;
                          },
                          controller: postCodeCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: 40050',
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
                                this.fetchCities(value.stateId!);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  if (_addressFormKey.currentState!.validate()) {
                    var requestServiceArgs = new RequestServiceArgument(
                        serviceProblem: _problem,
                        purchase: purchase,
                        // serviceCenter: requestServiceArgument.serviceCenter,
                        serviceRequestDate: _selectedDate,
                        // serviceRequestTime: _selectedTimeSlot,
                        serviceType: 'Request for Pick-up/Delivery',
                        address: new Address(
                          addressLine1: address1CT.text,
                          addressLine2: address2CT.text,
                          city: city.city,
                          cityId: city.cityId,
                          postcode: postCodeCT.text,
                          stateId: state.stateId,
                          state: state.state,
                        ));

                    Navigator.pushNamed(
                      context,
                      'reviewPickup',
                      arguments: requestServiceArgs != null
                          ? requestServiceArgs
                          : null,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
