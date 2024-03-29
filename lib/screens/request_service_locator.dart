import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/ServiceCenter.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/request_service_arguments.dart';
import 'package:khind/models/states.dart';
import 'dart:convert';

import 'package:khind/services/api.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';

class ServiceRequestLocator extends StatefulWidget {
  Purchase? data;
  ServiceRequestLocator({this.data});

  @override
  _ServiceRequestLocatorState createState() => _ServiceRequestLocatorState();
}

class _ServiceRequestLocatorState extends State<ServiceRequestLocator> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> states = [
    'Selangor',
    'Perak',
  ];

  List<States> _states = [];

  List<City> _cities = [];

  List<ServiceCenter> _serviceCenters = [];
  List<ServiceCenter> _filteredServiceCenters = [];
  late States state;
  late City city;
  bool showCity = false;

  @override
  void initState() {
    state = new States(countryId: "", state: "All", stateId: "", stateCode: "");
    city = new City(
      stateId: "",
      city: "All",
      cityId: "",
      postcodeId: "",
      postcode: "",
    );

    _cities = [city];

    super.initState();
    this.fetchStates();
    this.fetchServiceCenter();
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

      states.insert(0,
          new States(countryId: "", state: "All", stateId: "", stateCode: ""));

      setState(() {
        _states = states;
        state = states[0];
      });
    }
  }

  Future<void> fetchCities(String stateId) async {
    setState(() {
      city = new City(
          stateId: "", city: "All", cityId: "", postcodeId: "", postcode: "");
    });

    var url = Uri.parse(Api.endpoint + Api.GET_CITIES + "?state_id=$stateId");
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
      var cities = (resp['city'] as List).map((i) => City.fromJson(i)).toList();
      cities.insert(
          0,
          new City(
              stateId: "",
              city: "All",
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
  }

  Future<void> fetchServiceCenter() async {
    var url = Uri.parse(Api.endpoint + Api.GET_REQUEST_SERVICE);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };
    final response = await http.get(
      url,
      headers: authHeader,
    );

    // print("RESPONSE: $response");

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      var svcCenters =
          (resp['data'] as List).map((i) => ServiceCenter.fromJson(i)).toList();

      // print('CENTRES:  ${jsonEncode(svcCenters)}');

      setState(() {
        _serviceCenters = svcCenters;
        _filteredServiceCenters = svcCenters;
      });
    }
  }

  void filterServiceCenter() {
    List<ServiceCenter> filtered = List.from(_serviceCenters);

    // print("STATE: ${state.state} | ${city.cityId}");
    if (state.stateId != "") {
      filtered =
          _serviceCenters.where((e) => e.stateId == state.stateId).toList();
    }

    if (city.cityId != "") {
      filtered = _serviceCenters.where((e) => e.cityId == city.cityId).toList();
    }

    setState(() {
      _filteredServiceCenters = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Locate a Service Center'),
      // ),
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Locate a Service Center", isBack: true, hasActions: false),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
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
                  // Expanded(
                  //     flex: 1,
                  //     child: Container(
                  //         child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //           Container(
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 5, vertical: 2),
                  //               decoration: BoxDecoration(
                  //                   color: Colors.yellow[700],
                  //                   borderRadius: BorderRadius.circular(5)),
                  //               child: Text("State",
                  //                   style: TextStyles.textWhiteSm)),
                  //           Container(
                  //             child: DropdownButton<States>(
                  //               items:
                  //                   _states.map<DropdownMenuItem<States>>((e) {
                  //                 return DropdownMenuItem<States>(
                  //                   child: Text(
                  //                     e.state!,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     maxLines: 2,
                  //                   ),
                  //                   value: e,
                  //                 );
                  //               }).toList(),
                  //               isExpanded: true,
                  //               value: state,
                  //               onChanged: (value) {
                  //                 if (value != null && value.stateId != "") {
                  //                   setState(() {
                  //                     state = value;
                  //                     showCity = true;
                  //                     _cities = [];
                  //                     this.fetchCities(value.stateId!);
                  //                   });
                  //                   this.filterServiceCenter();
                  //                 } else {
                  //                   setState(() {
                  //                     _cities = [];
                  //                     showCity = false;
                  //                   });
                  //                   this.fetchServiceCenter();
                  //                 }
                  //               },
                  //             ),
                  //           )
                  //         ]))),
                  // showCity
                  //     ? Expanded(
                  //         flex: 1,
                  //         child: Container(
                  //             padding: EdgeInsets.only(left: 20),
                  //             child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 5, vertical: 2),
                  //                       decoration: BoxDecoration(
                  //                           color: Colors.yellow[700],
                  //                           borderRadius:
                  //                               BorderRadius.circular(5)),
                  //                       child: Text("City",
                  //                           style: TextStyles.textWhiteSm)),
                  //                   Container(
                  //                     child: DropdownButton<City>(
                  //                       items: _cities
                  //                           .map<DropdownMenuItem<City>>(
                  //                               (City value) {
                  //                         return DropdownMenuItem<City>(
                  //                           value: value,
                  //                           child: Text(
                  //                             value.city!,
                  //                             overflow: TextOverflow.ellipsis,
                  //                             maxLines: 2,
                  //                           ),
                  //                         );
                  //                       }).toList(),
                  //                       isExpanded: true,
                  //                       value: city,
                  //                       onChanged: (value) {
                  //                         setState(() {
                  //                           city = value!;
                  //                         });

                  //                         this.filterServiceCenter();
                  //                       },
                  //                     ),
                  //                   )
                  //                 ])))
                  //     : Expanded(flex: 1, child: Container()),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _filteredServiceCenters.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("No more data to show, tap to refresh",
                            style: TextStyle(color: Colors.black)),
                      ),
                    )
                  : LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredServiceCenters.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ServiceCard(
                              purchase: widget.data!,
                              serviceCenter: _filteredServiceCenters[index]);
                        },
                      )),
            )
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.serviceCenter,
    required this.purchase,
  }) : super(key: key);

  final ServiceCenter serviceCenter;
  final Purchase purchase;

  @override
  Widget build(BuildContext context) {
    final telephone =
        serviceCenter.telephone == null ? "" : serviceCenter.telephone;

    return GestureDetector(
      onTap: () {
        var requestServiceArgs = new RequestServiceArgument(
            purchase: purchase, serviceCenter: this.serviceCenter);
        Navigator.pushNamed(context, "requestDateDropIn",
            arguments: requestServiceArgs != null ? requestServiceArgs : null);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * 0.2,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              serviceCenter.serviceCenterName!,
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
              serviceCenter.address!,
              style: TextStyle(height: 1, fontSize: 12, color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Operating Hours: ",
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // height: 2,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                serviceCenter.operatingHours != null &&
                        serviceCenter.operatingHours != " "
                    ? Container(
                        child: Flexible(
                            child: Text('${serviceCenter.operatingHours!}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 12,
                                    color: Colors.black))),
                      )
                    : Container(child: Text("-"))
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
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(telephone!,
                      style: TextStyle(
                          height: 1, fontSize: 12, color: Colors.black)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
