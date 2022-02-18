import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/models/Postcode.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/shipping_address.dart';
import 'package:khind/models/states.dart';
import 'package:khind/models/user.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

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
  List<Postcode> postcodes = [];
  late States state;
  late City city;
  late Postcode postcode;
  String version = "";
  String buildNo = "";
  ShippingAddress? consumerAddress;

  @override
  void initState() {
    _init();
    _fetchStates();
    // _fetchConsumerAddress();
    // print("#USER: ${jsonEncode(widget.user)}");
    super.initState();
  }

  _init() {
    setState(() {
      city = new City(
        stateId: "",
        city: "--Select--",
        cityId: "",
        postcodeId: "",
        postcode: "",
      );
      state = new States(countryId: "", state: "--Select--", stateId: "", stateCode: "");
      postcode = new Postcode(id: "", postcode: "--Select--");
    });
    // print("#WIDGET>CONSUMERADDRESS: ${widget.consumerAddress}");
    if (widget.consumerAddress != null) {
      if (widget.consumerAddress?.address1 != null) {
        address1CT.text = widget.consumerAddress!.address1!;
      }
      if (widget.consumerAddress?.address2 != null) {
        address2CT.text = widget.consumerAddress!.address2!;
      }
      if (widget.consumerAddress?.city != null) {
        // city= newAddress!.city!;
      }
    }
  }

  // Future<void> _fetchConsumerAddress() async {
  //   final response = await Api.bearerGet('shippingaddress');
  //   print("#fetchConsumerAddress RESPONSE: $response");
  //   ShippingAddress? newAddress;

  //   if (response['data'] != null) {
  //     var shipAddress =
  //         (response['data']['addresses'] as List).map((i) => ShippingAddress.fromJson(i)).toList();

  //     if (response['data']['address_id'] != null) {
  //       shipAddress.forEach((elem) {
  //         if (response['data']['address_id'] == elem.addressId) {
  //           newAddress = elem;
  //         }
  //       });

  //       // print('#NEW ADDRESS: ${newAddress.toString()}');

  //       setState(() {
  //         consumerAddress = newAddress;
  //         if (newAddress?.address1 != null) {
  //           address1CT.text = newAddress!.address1!;
  //         }
  //         if (newAddress?.address2 != null) {
  //           address2CT.text = newAddress!.address2!;
  //         }
  //         if (newAddress?.city != null) {
  //           // city= newAddress!.city!;
  //         }
  //       });
  //     }
  //   }
  // }

  Future<void> _fetchStates() async {
    final response = await Api.bearerGet('provider/state.php', isCms: true);

    var newStates = (response['states'] as List).map((i) => States.fromJson(i)).toList();

    newStates.insert(0, new States(countryId: "", state: "--Select--", stateId: "", stateCode: ""));

    setState(() {
      states = newStates;
      state = newStates[0];
    });
  }

  Future<void> _fetchCities(String stateId) async {
    final response = await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var newCities = (response['city'] as List).map((i) => City.fromJson(i)).toList();

    newCities.insert(
        0, new City(stateId: "", city: "--Select--", cityId: "", postcodeId: "", postcode: ""));
    // print("#CITIES: $cities");
    var citySet = Set<String>();
    List<City> tempCities = newCities.where((e) => citySet.add(e.city!)).toList();

    var postcodeSet = Set<String>();
    List<Postcode> tempPostcodes = [];
    tempPostcodes.insert(0, new Postcode(id: "", postcode: "--Select--"));
    newCities.forEach((elem) {
      if (elem.postcode != null && elem.postcode != "") {
        tempPostcodes
            .add(Postcode.fromJson({'postcode_id': elem.postcodeId, 'postcode': elem.postcode}));
      }
    });
    List<Postcode> newPostcodes = tempPostcodes.where((e) => postcodeSet.add(e.postcode!)).toList();
    // log('#newPostcodes:  ${jsonEncode(newPostcodes)}');
    setState(() {
      cities = tempCities;
      city = tempCities[0];
      postcodes = newPostcodes;
      postcode = newPostcodes[0];
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
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> mapO2O = {
        'address_1': address1CT.text,
        'address_': address2CT.text,
        'zone_id': state.stateId,
        'company': "",
        'city': city.city,
        'postcode': postcode.postcode,
        'country': "Malaysia",
        'country_id': "129",
        "default": "1"
      };
      print("#MAP: $mapO2O");
      final respO2O = await Api.customPut('customers/${widget.user!.id}',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-Oc-Restadmin-Id': FlutterConfig.get("CLIENT_PASSWORD")
          },
          params: jsonEncode(mapO2O));

      print("#RESP020: $respO2O");

      if (respO2O != null && respO2O['success']) {
        final Map<String, dynamic> map = {
          'address_line1': address1CT.text,
          'address_line2': address2CT.text,
          'zone_id': state.stateId,
          'city_id': city.cityId,
          'postcode_id': postcode.id,
          'email': widget.user?.email
        };

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
                        child: Text("UPDATE ADDRESS", style: TextStyles.textSecondaryBold))),
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
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text('State', style: TextStyles.textDefault),
                        ),
                        // SizedBox(height: 5),
                        Container(
                          child: DropdownButton<States>(
                            // underline: SizedBox(),
                            items: states.map<DropdownMenuItem<States>>((e) {
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
                                // print("STATE: $value");
                                setState(() {
                                  cities = [];
                                  postcodes = [];
                                  state = value;
                                  city = new City(
                                      stateId: "",
                                      city: "All",
                                      cityId: "",
                                      postcodeId: "",
                                      postcode: "");
                                  // postcode = new Postcode(id: "", postcode: "");
                                  _fetchCities(value.stateId!);
                                });
                              } else {
                                postcodes = [];
                                cities = [];
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                cities.length > 0 ? SizedBox(height: 10) : Container(),
                Row(children: [
                  cities.length > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // padding: EdgeInsets.only(top: 15),
                                // width: width * 0.30,
                                child: Text('City', style: TextStyles.textDefault),
                              ),
                              // SizedBox(height: 10),
                              Container(
                                // padding: EdgeInsets.only(left: 10),
                                width: width * 0.4,
                                child: DropdownButton<City>(
                                  items: cities.map<DropdownMenuItem<City>>((e) {
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
                                      // this.onSelectCity(value.postcode!);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ))
                      : Container(),
                  postcodes.length > 0 ? SizedBox(width: 10) : Container(),
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
                                width: width * 0.25,
                                child: DropdownButton<Postcode>(
                                  items: postcodes.map<DropdownMenuItem<Postcode>>((e) {
                                    return DropdownMenuItem<Postcode>(
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
                                      // this.onSelectCity(value.postcode!);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ))
                      : Container(),
                ]),
                SizedBox(height: 10),
                errors.length > 0
                    ? Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                                errors.map((e) => Text(e, style: TextStyles.textWarning)).toList()))
                    : Container(),
                SizedBox(height: 10),
                Container(
                    alignment: Alignment.center,
                    width: width,
                    padding: const EdgeInsets.only(bottom: 10, top: 15),
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                    child: InkWell(
                        // onTap: () => _handleUpdate(),
                        onTap: () => _handleUpdate(),
                        child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text("Update", style: TextStyles.textWhiteBold))))
              ])
            ])));
  }
}
