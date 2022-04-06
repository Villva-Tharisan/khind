import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/models/Postcode.dart';
import 'package:khind/models/Postcodes.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/shipping_address.dart';
import 'package:khind/models/states.dart';
import 'package:khind/models/user.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class UpdateAddress extends StatefulWidget {
  final User? user;
  final ShippingAddress? consumerAddress;
  UpdateAddress({this.user, this.consumerAddress});

  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final toolTipKey = GlobalKey<State<Tooltip>>();
  final storage = new FlutterSecureStorage();
  TextEditingController postCodeCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  bool isLoading = false;
  String errorMsg = "";
  List errors = [];
  final textStyle = TextStyle(fontSize: 14);
  bool canEditAddress = false;
  List<City> cities = [];
  List<States> states = [];
  Postcodes postcode = new Postcodes(postcodeId: "", postcode: "--Select--");
  List<Postcodes> postcodes = [];
  States? state;
  City? city;
  String version = "";
  String buildNo = "";
  ShippingAddress? consumerAddress;
  String? token;

  @override
  void initState() {
    _init();
    _fetchLocation();
    _loadToken();
    super.initState();
  }

  _init() {
    if (widget.consumerAddress != null) {
      if (widget.consumerAddress?.address1 != null) {
        address1CT.text = widget.consumerAddress!.address1!;
      }
      if (widget.consumerAddress?.address2 != null) {
        address2CT.text = widget.consumerAddress!.address2!;
      }
    }
  }

  _loadToken() async {
    final accessToken = await storage.read(key: TOKEN);

    setState(() {
      token = accessToken;
    });
  }

  Future<void> _fetchLocation() async {
    await _fetchStates();
    await _fetchPostcode();
  }

  Future<void> _fetchPostcode() async {
    final response = await Api.bearerGet('provider/postcode.php', isCms: true);

    var postcodeList = (response['postcodes'] as List).map((i) => Postcodes.fromJson(i)).toList();
    var availableStates = states.map((e) => e.stateId).toSet().toList();
    var postcodeSet = Set<String>();
    List<Postcodes> tempPostcodes =
        postcodeList.where((e) => postcodeSet.add(e.postcode!)).toList();
    var availablePostcodes =
        tempPostcodes.where((e) => availableStates.contains(e.stateId)).toList();
    availablePostcodes.insert(0, new Postcodes(postcodeId: "", postcode: "--Select--"));

    setState(() {
      postcodes = availablePostcodes;
      postcode = availablePostcodes[0];
    });
  }

  Future<void> onSelectPostcode(postcode) async {
    var selectedPostcode = postcodes.where((e) => e.postcode == postcode?.postcode).first;

    await _fetchCities(selectedPostcode.stateId!);
    var selectedCity = cities.where((e) => e.cityId == selectedPostcode.cityId).first;

    var selectedState =
        states.where((element) => element.stateId == selectedPostcode.stateId).first;

    setState(() {
      city = selectedCity;
      state = selectedState;
    });
  }

  Future<void> _fetchStates() async {
    final response = await Api.bearerGet('provider/state.php', isCms: true);

    var newStates = (response['states'] as List).map((i) => States.fromJson(i)).toList();

    setState(() {
      states = newStates;
      // state = newStates[0];
    });
  }

  Future<void> _fetchCities(String stateId) async {
    final response = await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var newCities = (response['city'] as List).map((i) => City.fromJson(i)).toList();

    // print("#CITIES: $cities");
    var citySet = Set<String>();
    List<City> tempCities = newCities.where((e) => citySet.add(e.city!)).toList();

    // var postcodeSet = Set<String>();
    // List<Postcode> tempPostcodes = [];
    // tempPostcodes.insert(0, new Postcode(id: "", postcode: "--Select--"));
    // newCities.forEach((elem) {
    //   if (elem.postcode != null && elem.postcode != "") {
    //     tempPostcodes
    //         .add(Postcode.fromJson({'postcode_id': elem.postcodeId, 'postcode': elem.postcode}));
    //   }
    // });
    // List<Postcode> newPostcodes = tempPostcodes.where((e) => postcodeSet.add(e.postcode!)).toList();
    // log('#newPostcodes:  ${jsonEncode(newPostcodes)}');
    setState(() {
      cities = tempCities;
      // city = tempCities[0];
    });
  }

  @override
  void dispose() {
    address1CT.dispose();
    address2CT.dispose();
    super.dispose();
  }

  void _clearTextField() {
    address1CT.clear();
    address2CT.clear();
  }

  void _handleUpdate() async {
    if (Helpers.isEmpty(address1CT.text) ||
        Helpers.isEmpty(postcode.postcode) ||
        Helpers.isEmpty(city!.city) ||
        Helpers.isEmpty(state!.state)) {
      return setState(() {
        isLoading = false;
        errors.add("Please key in mandatory field");
      });
    }
    // print("#BYPASS");

    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> mapO2O = {
        'address': [
          {
            'firstname': widget.user?.firstname,
            'lastname': widget.user?.lastname,
            'address_1': address1CT.text,
            'address_2': address2CT.text,
            'zone_id': state!.stateId,
            'company': "",
            'city': city!.city,
            'postcode': postcode.postcode,
            'country': "Malaysia",
            'country_id': "129",
            "default": "1"
          }
        ]
      };
      print("#MAPO20: $mapO2O | USER: ${widget.user?.id}");
      final respO2O = await Api.customPut('customers/${widget.user?.id}',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-Oc-Restadmin-Id': FlutterConfig.get("CLIENT_PASSWORD")
          },
          params: jsonEncode(mapO2O));

      // print("#RESP020: $respO2O");

      if (respO2O != null && respO2O['success']) {
        final Map<String, dynamic> map = {
          'address_line_1': address1CT.text,
          'address_line_2': address2CT.text,
          'zone_id': state!.stateId,
          'city_id': city!.cityId,
          'postcode_id': postcode.postcodeId,
          'email': widget.user?.email,
          'token': token
        };

        print("#MAP: $map");

        final response =
            await Api.bearerPost('provider/update_address.php', queryParams: map, isCms: true);

        setState(() {
          isLoading = true;
          errorMsg = "";
          errors = [];
        });
        Navigator.pop(context);

        if (response['success']) {
          Helpers.showAlert(context, title: 'Address successfully updated', hasAction: true,
              onPressed: () {
            // _clearTextField();
            setState(() {
              errors = [];
            });
            Navigator.pop(context);
            Navigator.pop(context);
          },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text("Address has been successfully updated")),
                ],
              ));
        } else {
          if (response['error'] != null) {
            setState(() {
              isLoading = false;
              errorMsg = "Internal Server Error!";

              if (response['error'] is LinkedHashMap) {
                (response['error'] as LinkedHashMap).forEach((key, value) {
                  errors.add(value);
                });
              }
            });
          } else {
            setState(() {
              isLoading = false;
              errors.add("Internal Server Error!");
            });
          }
        }
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        isLoading = false;
        errors.add("Internal Server Error!");
      });
    }
  }

  Widget _renderExitIcon() {
    return Positioned(
        right: 5,
        top: 5,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(child: Icon(Icons.close, size: 20, color: Colors.white)))));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    const horContentPad = 10.0;

    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Stack(children: [
              _renderExitIcon(),
              Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    child: Container(
                        alignment: Alignment.center,
                        width: width,
                        padding: const EdgeInsets.only(bottom: 10, top: 15),
                        child: Text("UPDATE ADDRESS", style: TextStyles.textPrimaryBold))),
                Divider(color: Colors.grey[300]),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text('Address Line 1', style: TextStyles.textDefault),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
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
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.secondary),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'eg: No 78 Jalan Mawar',
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text('Address Line 2', style: TextStyles.textDefault),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: null,
                            validator: (value) {
                              return null;
                            },
                            controller: address2CT,
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.secondary),
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'eg: Puchong Perdana',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            )),
                      ],
                    )),
                SizedBox(height: 10),
                postcodes.length > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // padding: EdgeInsets.only(top: 15),
                              // width: width * 0.30,
                              child: Text('Postcode', style: TextStyles.textDefault),
                            ),
                            // SizedBox(height: 5),
                            Container(
                              // padding: EdgeInsets.only(left: 10),
                              // width: width * 0.25,
                              child: DropdownButton<Postcodes>(
                                items: postcodes.map<DropdownMenuItem<Postcodes>>((e) {
                                  return DropdownMenuItem<Postcodes>(
                                    child: Text(
                                      e.postcode as String,
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
                                    this.onSelectPostcode(value);
                                    // this.onSelectCity(value.postcode!);
                                  });
                                },
                              ),
                            ),
                          ],
                        ))
                    : Container(),
                SizedBox(height: 20),
                city != null
                    ? Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            child: Text('City *', style: TextStyles.textWarning),
                          ),
                          SizedBox(height: 10.0),
                          Text(city!.city!, style: TextStyles.textDefault)
                        ]))
                    : Container(),
                SizedBox(height: 20),
                state != null
                    ? Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            child: Text('State *', style: TextStyles.textWarning),
                          ),
                          SizedBox(height: 10.0),
                          Text(state!.state!, style: TextStyles.textDefault)
                        ]))
                    : Container(),
                SizedBox(height: 10),
                errors.length > 0
                    ? Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                                errors.map((e) => Text(e, style: TextStyles.textWarning)).toList()))
                    : Container(),
                SizedBox(height: 10),
                InkWell(
                    onTap: () => _handleUpdate(),
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 10, top: 15),
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                        child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text("Update", style: TextStyles.textWhiteBold))))
              ])
            ])));
  }
}
