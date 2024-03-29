import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/ServiceCenter.dart';
import 'package:khind/models/address.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/request_service_arguments.dart';
import 'package:khind/models/service_problem.dart';
import 'package:khind/models/shipping_address.dart';
import 'package:khind/models/states.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/states.dart';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';

import '../models/Postcodes.dart';

class RequestDateDropIn extends StatefulWidget {
  Purchase? data;
  RequestDateDropIn({this.data});

  @override
  _RequestDateDropInState createState() => _RequestDateDropInState();
}

class _RequestDateDropInState extends State<RequestDateDropIn> {
  static final GlobalKey<FormState> _basicFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _serviceFormKey = GlobalKey<FormState>();
  TextEditingController remarkCT = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // TextEditingController postCodeCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  List<String> _timesSlot = ["AM", "PM"];
  String _selectedTimeSlot = "AM";
  String _selectedDate = '';
  List<States> _states = [];
  List<States> _svcCenterStates = [];
  List<ServiceCenter> _svcCenters = [];
  List<ServiceCenter> _filteredSvcCenters = [];
  List<String> _deliveryOptions = ["Yes", "No"];
  List<ServiceProblem> _problems = [];
  List<City> _cities = [];
  List<String> postcodes = [];
  List<Postcodes> postcodeModels = [];
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
  bool dateError = false;
  @override
  void initState() {
    purchase = widget.data!;
    state = new States(countryId: "", state: "--Select--", stateId: "", stateCode: "");

    serviceCenterState = new States(countryId: "", state: "--Select--", stateId: "", stateCode: "");

    // _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    city = new City(
      stateId: "",
      city: "--Select--",
      cityId: "",
      postcodeId: "",
      postcode: "",
    );

    _cities = [city];

    var date = new DateTime.now();
    var firstDayMonth = new DateTime(date.year, date.month, 0);
    _maxDate = Jiffy(date).add(months: 1).dateTime;
    _fetchMasterData();
    super.initState();
  }

  Future<void> fetchStates() async {
    final response = await Api.bearerGet('provider/state.php', isCms: true);

    var states = (response['states'] as List).map((i) => States.fromJson(i)).toList();

    states.insert(0, new States(countryId: "", state: "--Select--", stateId: "", stateCode: ""));

    setState(() {
      _states = states;
      state = states[0];
    });
    await this.fetchConsumerAddress();
  }

  Future<void> _fetchMasterData() async {
    await this.fetchStates();
    await this.fetchServiceCenter();
    await this.fetchPostcode();
    await this.fetchProblems();
  }

  Future<void> fetchServiceCenter() async {
    final response = await Api.bearerGet('provider/khind_service.php', isCms: true);

    // print("RESPONSE: $response");
    var svcCenters = (response['data'] as List).map((i) => ServiceCenter.fromJson(i)).toList();

    var availableStates = svcCenters.map((e) => e.stateId).toSet().toList();
    var states = _states.where((e) => availableStates.contains(e.stateId)).toList();

    states.insert(0, new States(countryId: "", state: "--Select--", stateId: "", stateCode: ""));

    setState(() {
      _svcCenterStates = states;
    });

    svcCenters = svcCenters.where((e) => e.stateId != null).toList();

    setState(() {
      _svcCenters = svcCenters;
      _selectedServiceCenter = svcCenters[0];
      serviceCenterState = states[0];
    });
  }

  Future<void> onSelectState(String stateId) async {
    var filteredSvcCenter = _svcCenters.where((element) => element.stateId == stateId).toList();

    var initialName = "Choose City";
    if (filteredSvcCenter.length == 0) {
      initialName = "Not available";
    }
    filteredSvcCenter.insert(
        0, new ServiceCenter(serviceCenterId: "0", serviceCenterName: initialName));

    setState(() {
      _filteredSvcCenters = filteredSvcCenter;
      _selectedServiceCenter = filteredSvcCenter[0];
    });
  }

  Future<void> fetchCities(String stateId) async {
    final response = await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var cities = (response['city'] as List).map((i) => City.fromJson(i)).toList();

    cities.insert(
        0, new City(stateId: "", city: "--Select--", cityId: "", postcodeId: "", postcode: ""));

    // print("#CITIES: $cities");
    var citySet = Set<String>();
    var postcodeSet = Set<String>();
    List<String> tempPostcodes = [];
    List<City> newCities = cities.where((e) => citySet.add(e.city!)).toList();

    // print('#newPostcodes:  $newPostcodes');
    setState(() {
      _cities = newCities;
      city = newCities[0];
    });
  }

  Future<void> fetchPostcode() async {
    final response = await Api.bearerGet('provider/postcode.php', isCms: true);

    var postcodeList = (response['postcodes'] as List).map((i) => Postcodes.fromJson(i)).toList();

    setState(() {
      postcodes = postcodeList.map((e) => e.postcode!).toList();
      postcodeModels = postcodeList;
    });
  }

  Future<void> onSelectPostcode(postcode) async {
    var selectedPostcode = postcodeModels.where((e) => e.postcode == postcode).first;

    await this.fetchCities(selectedPostcode.stateId!);
    var selectedCity = _cities.where((e) => e.cityId == selectedPostcode.cityId).first;

    var selectedState =
        _states.where((element) => element.stateId == selectedPostcode.stateId).first;

    setState(() {
      city = selectedCity;
      state = selectedState;
    });
  }

  Future<void> fetchConsumerAddress() async {
    final response = await Api.bearerGet('shippingaddress');
    ShippingAddress? newAddress;
    if (response['data'] != null) {
      var addressId = response['data']['address_id'] as String;
      var shipAddress =
          (response['data']['addresses'] as List).map((i) => ShippingAddress.fromJson(i)).toList();

      if (addressId != null) {
        newAddress = shipAddress.where((e) => e.addressId == addressId).toList().first;

        if (_states == null ||
            _states
                    .where((element) =>
                        element.state!.toLowerCase() == newAddress!.state!.toLowerCase())
                    .toList()
                    .length ==
                0) {
          return;
        }
        var currentState = _states
            .where((element) => element.state!.toLowerCase() == newAddress!.state!.toLowerCase())
            .toList()
            .first;

        await this.fetchCities(currentState.stateId!);

        if (_cities == null ||
            _cities.where((element) => element.city == newAddress!.city).toList().length == 0) {
          return;
        }

        var currentCity =
            _cities.where((element) => element.city == newAddress!.city).toList().first;

        var currentPostcode =
            postcodes.where((element) => element == newAddress!.postcode).toList();
        var selectedPostcode = "";
        if (currentPostcode.length == 0) {
          selectedPostcode = newAddress.postcode!;
          setState(() {
            postcodes.add(selectedPostcode);
            postcode = selectedPostcode;
          });
        } else {
          selectedPostcode = currentPostcode.first;
          setState(() {
            postcode = selectedPostcode;
          });
        }

        setState(() {
          if (newAddress?.address1 != null) {
            address1CT.text = newAddress!.address1!;
          }
          if (newAddress?.address2 != null) {
            address2CT.text = newAddress!.address2!;
          }

          state = currentState;
          city = currentCity;
        });
      }
    }
  }

  Future<void> fetchProblems() async {
    final response = await Api.bearerGet('provider/problems.php', isCms: true);

    var problems = (response['data'] as List).map((i) => ServiceProblem.fromJson(i)).toList();

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
          customTitle: Row(children: [
            Text("Request Date", style: TextStyles.textDefaultLg),
            SizedBox(width: 10),
            CustomCard(
                borderRadius: BorderRadius.circular(10),
                label: "Drop-In",
                textStyle: TextStyles.textWhiteSm,
                color: AppColors.warmGrey,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7))
          ]),
          hasActions: false,
          isBack: true),
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
          Form(
            key: _serviceFormKey,
            child: Container(
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
                  BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  _svcCenterStates.isEmpty
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(left: 10),
                          width: width * 0.45,
                          child: DropdownButtonFormField<States>(
                            items: _svcCenterStates.map<DropdownMenuItem<States>>((e) {
                              return DropdownMenuItem<States>(
                                child: Text(
                                  e.state!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                value: e,
                              );
                            }).toList(),
                            validator: (value) {
                              if (value!.stateId! == "") {
                                return 'Please select state';
                              }
                              return null;
                            },
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
                          ? DropdownButtonFormField<ServiceCenter>(
                              items: _filteredSvcCenters.map<DropdownMenuItem<ServiceCenter>>((e) {
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
                              validator: (value) {
                                if (value!.serviceCenterId! == "") {
                                  return 'Please select service center';
                                }
                                return null;
                              },
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
              // initialSelectedDate: DateTime.now(),
              selectableDayPredicate: (DateTime date) {
                if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
                  return false;
                }
                return true;
              },
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _selectedDate = DateFormat('yyyy-MM-dd')
                      .format(DateFormat('yyyy-MM-dd hh:mm:ss').parse(args.value.toString()));
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
                BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
              ],
              borderRadius: BorderRadius.circular(7.5),
            ),
          ),
          dateError
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '*Please select date',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              : Container(),
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
                BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
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
                                items: _timesSlot.map<DropdownMenuItem<String>>((e) {
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
                BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
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
                                items: _problems.map<DropdownMenuItem<ServiceProblem>>((e) {
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
                                return null;
                              },
                              controller: remarkCT,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
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
                                items: _deliveryOptions.map<DropdownMenuItem<String>>((e) {
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
                SizedBox(height: 5),
                Text(
                    "* Courier fee of RM 15.00 will be charged if delivery service after repair is needed",
                    style: TextStyles.textWarning.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.start),
                //address
                _selectedDelivery == "Yes" ? renderAddressForm(width, context) : Container(),
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
              child: RoundButton(
                title: 'Book',
                onPressed: () {
                  setState(() {
                    showError = false;
                    dateError = false;
                  });
                  if (_selectedServiceCenter == null ||
                      _selectedServiceCenter.serviceCenterId == "0") {
                    setState(() {
                      showError = true;
                    });
                    return;
                  }
                  if (_selectedDate == '') {
                    setState(() {
                      dateError = true;
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
                    delivery: _selectedDelivery,
                    purchase: purchase,
                    serviceCenter: _selectedServiceCenter,
                  );

                  if (_selectedDelivery == "Yes") {
                    if (_basicFormKey.currentState!.validate() &&
                        _addressFormKey.currentState!.validate() &&
                        _serviceFormKey.currentState!.validate()) {
                      requestServiceArgs.address = new Address(
                        addressLine1: address1CT.text,
                        addressLine2: address2CT.text,
                        city: city.city,
                        cityId: city.cityId,
                        postcode: postcode,
                        stateId: state.stateId,
                        state: state.state,
                      );
                      Navigator.pushNamed(
                        context,
                        'review',
                        arguments: requestServiceArgs != null ? requestServiceArgs : null,
                      );
                    }
                  } else {
                    if (_basicFormKey.currentState!.validate() &&
                        _serviceFormKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        'review',
                        arguments: requestServiceArgs != null ? requestServiceArgs : null,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: width * 0.45,
                  child: DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    showSearchBox: true,
                    // showSelectedItem: true,
                    items: postcodes,
                    selectedItem: postcode,
                    onChanged: (value) {
                      setState(() {
                        postcode = value!;
                        this.onSelectPostcode(value);
                      });
                    },
                    validator: (value) {
                      if (value == "") return "Please enter postcode";
                      return null;
                    },
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select a country",
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30),
          city != null
              ? Container(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text('City', style: TextStyles.textDefault),
                      )),
                  SizedBox(height: 10.0),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.only(left: 30),
                          // alignment: Alignment.centerRight,
                          child: Text(city.city!, style: TextStyles.textDefault)))
                ]))
              : Container(),
          SizedBox(height: 30),
          state != null
              ? Container(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text('State', style: TextStyles.textDefault),
                      )),
                  SizedBox(height: 10.0),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.only(left: 30),
                          // alignment: Alignment.centerRight,
                          child: Text(state.state!, style: TextStyles.textDefault)))
                ]))
              : Container(),
          // SizedBox(height: 20),
          // _cities.length > 0
          //     ? Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             padding: EdgeInsets.only(top: 15),
          //             width: width * 0.30,
          //             child: Text('City'),
          //           ),
          //           SizedBox(width: 15),
          //           Flexible(
          //             child: Container(
          //               padding: EdgeInsets.only(left: 10),
          //               width: width * 0.45,
          //               child: DropdownButtonFormField<City>(
          //                 items: _cities.map<DropdownMenuItem<City>>((e) {
          //                   return DropdownMenuItem<City>(
          //                     child: Text(
          //                       e.city!,
          //                       overflow: TextOverflow.ellipsis,
          //                       maxLines: 2,
          //                     ),
          //                     value: e,
          //                   );
          //                 }).toList(),
          //                 isExpanded: true,
          //                 value: city,
          //                 onChanged: city.cityId == ""
          //                     ? (value) {
          //                         setState(() {
          //                           city = value!;
          //                           // this.onSelectCity(value.postcode!);
          //                         });
          //                       }
          //                     : null,
          //                 validator: (value) {
          //                   if (value!.cityId! == "") return "Please enter city";
          //                   return null;
          //                 },
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //     : Container(),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.only(top: 15),
          //       width: width * 0.30,
          //       child: Text('State'),
          //     ),
          //     SizedBox(width: 15),
          //     Flexible(
          //       child: Container(
          //         padding: EdgeInsets.only(left: 10),
          //         width: width * 0.45,
          //         child: DropdownButtonFormField<States>(
          //           isExpanded: true,
          //           hint: Text('State'),
          //           value: state,
          //           onChanged: state.stateId == ""
          //               ? (newValue) {
          //                   setState(() {
          //                     state = newValue!;
          //                     // this.fetchCities(newValue.stateId!);
          //                   });
          //                 }
          //               : null,
          //           items: _states.map((item) {
          //             return DropdownMenuItem(
          //               child: new Text(item.state!),
          //               value: item,
          //             );
          //           }).toList(),
          //           validator: (value) {
          //             if (value!.stateId! == "") return "Please enter state";
          //             return null;
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
