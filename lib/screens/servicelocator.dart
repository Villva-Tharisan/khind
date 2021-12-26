import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/ServiceCenter.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/states.dart';
import 'dart:convert';

import 'package:khind/services/api.dart';
import 'package:khind/util/helpers.dart';

class ServiceLocator extends StatefulWidget {
  const ServiceLocator({Key? key}) : super(key: key);

  @override
  _ServiceLocatorState createState() => _ServiceLocatorState();
}

class _ServiceLocatorState extends State<ServiceLocator> {
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

  @override
  void initState() {
    state = new States(countryId: "", state: "--Select--", stateId: "", stateCode: "");
    city = new City(
      stateId: "",
      city: "--Select--",
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
      var states = (resp['states'] as List).map((i) => States.fromJson(i)).toList();

      states.insert(0, new States(countryId: "", state: "--Select--", stateId: "", stateCode: ""));

      setState(() {
        _states = states;
        state = states[0];
      });
    }
  }

  Future<void> fetchCities(String stateId) async {
    // setState(() {
    //   city = new City(
    //       stateId: "",
    //       city: "--Select--",
    //       cityId: "",
    //       postcodeId: "",
    //       postcode: "");
    // });

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
          0, new City(stateId: "", city: "--Select--", cityId: "", postcodeId: "", postcode: ""));

      setState(() {
        _cities = cities;
        city = cities[0];
      });
    }
  }

  Future<void> fetchServiceCenter() async {
    var url = Uri.parse(Api.endpoint + Api.GET_SERVICE);
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
      var svcCenters = (resp['data'] as List).map((i) => ServiceCenter.fromJson(i)).toList();

      setState(() {
        _serviceCenters = svcCenters;
        _filteredServiceCenters = svcCenters;
      });
    }
  }

  void filterServiceCenter() {
    var filtered = _serviceCenters;
    if (state.stateId != "") {
      filtered = _serviceCenters.where((e) => e.stateId == state.stateId).toList();
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
                        if (value != null && value.stateId != "") {
                          this.fetchCities(value.stateId!);
                        }

                        setState(() {
                          state = value!;
                        });

                        this.filterServiceCenter();
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
                    child: DropdownButton<City>(
                      items: _cities.map<DropdownMenuItem<City>>((City value) {
                        return DropdownMenuItem<City>(
                          value: value,
                          child: Text(
                            value.city!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                      value: city,
                      onChanged: (value) {
                        setState(() {
                          city = value!;
                        });

                        this.filterServiceCenter();
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
            Expanded(
              child: _filteredServiceCenters.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("No more data to show, tap to refresh",
                            style: TextStyle(color: Colors.black)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredServiceCenters.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ServiceCard(serviceCenter: _filteredServiceCenters[index]);
                      },
                    ),
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
  }) : super(key: key);

  final ServiceCenter serviceCenter;

  @override
  Widget build(BuildContext context) {
    final telephone = serviceCenter.telephone == null ? "" : serviceCenter.telephone;

    return Container(
      width: double.infinity,
      height: 140,
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
            children: [
              Text(
                "Operating Hours:",
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
                child: Text(serviceCenter.operatingHours!,
                    style: TextStyle(height: 1, fontSize: 12, color: Colors.black)),
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
                child: Text(telephone!,
                    style: TextStyle(height: 1, fontSize: 12, color: Colors.black)),
              )
            ],
          )
        ],
      ),
    );
  }
}
