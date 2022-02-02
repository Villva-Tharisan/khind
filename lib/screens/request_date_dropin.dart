import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/ServiceCenter.dart';
import 'package:khind/models/address.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/request_service_arguments.dart';
import 'package:khind/models/service_problem.dart';
import 'package:khind/models/states.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/states.dart';
import 'dart:convert';

class RequestDateDropIn extends StatefulWidget {
  Purchase? data;
  RequestDateDropIn({this.data});

  @override
  _RequestDateDropInState createState() => _RequestDateDropInState();
}

class _RequestDateDropInState extends State<RequestDateDropIn> {
  static final GlobalKey<FormState> _basicFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  TextEditingController remarkCT = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // TextEditingController postCodeCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  List<String> _timesSlot = ["AM", "PM"];
  String _selectedTimeSlot = "AM";
  String _selectedDate = '';
  List<States> _states = [];
  List<ServiceCenter> _svcCenters = [];
  List<ServiceCenter> _filteredSvcCenters = [];
  List<String> _deliveryOptions = ["Yes", "No"];
  List<ServiceProblem> _problems = [];
  List<City> _cities = [];
  List<String> postcodes = [];
  String postcode = "";
  late States state;
  late States serviceCenterState;
  late ServiceCenter _selectedServiceCenter;
  late City city;
  late ServiceProblem _problem;
  String _selectedDelivery = "No";
  late Purchase purchase;
  late DateTime _maxDate;
  bool showError = false;
  @override
  void initState() {
    purchase = widget.data!;
    state = new States(
        countryId: "", state: "--Select--", stateId: "", stateCode: "");

    serviceCenterState = new States(
        countryId: "", state: "--Select--", stateId: "", stateCode: "");

    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    city = new City(
      stateId: "",
      city: "--Select--",
      cityId: "",
      postcodeId: "",
      postcode: "",
    );

    var date = new DateTime.now();
    var firstDayMonth = new DateTime(date.year, date.month, 0);
    _maxDate = Jiffy(date).add(months: 1).dateTime;

    super.initState();
    this.fetchStates();
    this.fetchServiceCenter();
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
      serviceCenterState = states[0];
    });
  }

  Future<void> fetchServiceCenter() async {
    final response =
        await Api.bearerGet('provider/khind_service.php', isCms: true);

    // print("RESPONSE: $response");
    var svcCenters = (response['data'] as List)
        .map((i) => ServiceCenter.fromJson(i))
        .toList();

    setState(() {
      _svcCenters = svcCenters;
      _selectedServiceCenter = svcCenters[0];
    });
  }

  Future<void> onSelectState(String stateId) async {
    var filteredSvcCenter =
        _svcCenters.where((element) => element.stateId == stateId).toList();

    var initialName = "Choose City";
    if (filteredSvcCenter.length == 0) {
      initialName = "Not avaiable";
    }
    filteredSvcCenter.insert(
        0,
        new ServiceCenter(
            serviceCenterId: "0", serviceCenterName: initialName));

    setState(() {
      _filteredSvcCenters = filteredSvcCenter;
      _selectedServiceCenter = filteredSvcCenter[0];
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
    // print("#CITIES: $cities");
    var citySet = Set<String>();
    var postcodeSet = Set<String>();
    List<String> tempPostcodes = [];
    List<City> newCities = cities.where((e) => citySet.add(e.city!)).toList();
    newCities.forEach((elem) {
      if (elem.postcode != null) {
        tempPostcodes.add(elem.postcode!);
      }
    });
    List<String> newPostcodes =
        tempPostcodes.where((e) => postcodeSet.add(e)).toList();
    // print('#newPostcodes:  $newPostcodes');
    setState(() {
      _cities = newCities;
      city = newCities[0];
      postcodes = newPostcodes;
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
      // postCodeCT.text = postCode;
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
            'Select Service Center',
            style: TextStyles.textDefaultBold,
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
                width: 0.4,
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(7.5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                _states.isEmpty
                    ? Container()
                    : Container(
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
                          value: serviceCenterState,
                          onChanged: (value) {
                            setState(() {
                              serviceCenterState = value!;
                              this.onSelectState(value.stateId!);
                            });
                          },
                        ),
                      ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    width: width * 0.45,
                    child: !_filteredSvcCenters.isEmpty
                        ? DropdownButton<ServiceCenter>(
                            items: _filteredSvcCenters
                                .map<DropdownMenuItem<ServiceCenter>>((e) {
                              return DropdownMenuItem<ServiceCenter>(
                                child: Text(
                                  e.serviceCenterName!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                value: e,
                              );
                            }).toList(),
                            isExpanded: true,
                            value: _selectedServiceCenter,
                            onChanged: (value) {
                              setState(() {
                                _selectedServiceCenter = value!;
                              });
                            },
                          )
                        : Container(),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Select Date',
            style: TextStyles.textDefaultBold,
          ),
          SizedBox(
            height: 10,
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
              minDate: DateTime.now(),
              maxDate: _maxDate,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 0.4,
                color: Colors.grey.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
              borderRadius: BorderRadius.circular(7.5),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Select Time',
            style: TextStyles.textDefaultBold,
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
                width: 0.4,
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(7.5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
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
                width: 0.4,
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(7.5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
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
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text('Remarks:'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.60,
                      child: Form(
                        key: _basicFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter remark';
                                }
                                return null;
                              },
                              controller: remarkCT,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          //delivery opt
          SizedBox(height: 10),
          Text(
            'Would you like your product be delivered after service',
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
                width: 0.4,
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(7.5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey[200]!,
                    offset: Offset(0, 10)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Delivery:",
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width * 0.45,
                        child: !_deliveryOptions.isEmpty
                            ? DropdownButton<String>(
                                items: _deliveryOptions
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
                                value: _selectedDelivery,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDelivery = value!;
                                  });
                                },
                              )
                            : Container(),
                      ),
                    )
                  ],
                ),
                //address
                _selectedDelivery == "Yes"
                    ? renderAddressForm(width, context)
                    : Container(),
                !showError
                    ? Container()
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '*Please select service center',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
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
                  setState(() {
                    showError = false;
                  });
                  if (_selectedServiceCenter == null ||
                      _selectedServiceCenter.serviceCenterId == "0") {
                    setState(() {
                      showError = true;
                    });
                    return;
                  }
                  var requestServiceArgs = new RequestServiceArgument(
                    serviceProblem: _problem,
                    // purchase: requestServiceArgument.purchase,
                    // serviceCenter: requestServiceArgument.serviceCenter,
                    serviceRequestDate: _selectedDate,
                    serviceRequestTime: _selectedTimeSlot,
                    serviceType: 'Drop-In',
                    remarks: remarkCT.text,
                    address: new Address(
                      addressLine1: address1CT.text,
                      addressLine2: address2CT.text,
                      city: city.city,
                      cityId: city.cityId,
                      postcode: postcode,
                      stateId: state.stateId,
                      state: state.state,
                    ),
                    delivery: _selectedDelivery,
                    purchase: purchase,
                    serviceCenter: _selectedServiceCenter,
                  );

                  if (_selectedDelivery == "Yes") {
                    if (_basicFormKey.currentState!.validate() &&
                        _addressFormKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        'review',
                        arguments: requestServiceArgs != null
                            ? requestServiceArgs
                            : null,
                      );
                    }
                  } else {
                    if (_basicFormKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        'review',
                        arguments: requestServiceArgs != null
                            ? requestServiceArgs
                            : null,
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form renderAddressForm(double width, BuildContext context) {
    return Form(
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
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg: No 78 Jalan Mawar',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                    return null;
                  },
                  controller: address2CT,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg: Puchong Perdana',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
          _cities.length > 0
              ? Row(
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
                )
              : Container(),
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
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: width * 0.45,
                  child: DropdownButton<String>(
                    items: postcodes.map<DropdownMenuItem<String>>((e) {
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
                    value: postcode,
                    onChanged: (value) {
                      setState(() {
                        postcode = value!;
                        // this.onSelectCity(value.postcode!);
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
