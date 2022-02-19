import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:khind/components/bg_painter.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/Postcode.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/states.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _basicFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _pwdFormKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController firstNameCT = new TextEditingController();
  TextEditingController lastNameCT = new TextEditingController();
  TextEditingController mobileNoCT = new TextEditingController();
  TextEditingController dobCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  TextEditingController postcodeCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController confirmPasswordCT = new TextEditingController();
  FocusNode focusEmail = new FocusNode();
  FocusNode focusFirstName = new FocusNode();
  FocusNode focusLastName = new FocusNode();
  FocusNode focusMobile = new FocusNode();
  FocusNode focusDob = new FocusNode();
  FocusNode focusAddress1 = new FocusNode();
  FocusNode focusAddress2 = new FocusNode();
  FocusNode focusPostcode = new FocusNode();
  FocusNode focusPwd = new FocusNode();
  FocusNode focusConfirmPwd = new FocusNode();
  FocusNode focusCity = new FocusNode();
  FocusNode focusState = new FocusNode();
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String errorMsg = "";
  List errors = [];
  DateTime now = DateTime.now();
  DateTime selectedDob = DateTime(DateTime.now().year - 10);
  bool showPwdForm = false;
  bool showAddressForm = false;
  bool agreeTerm = false;
  late List<States> states = [];
  late List<City> cities = [];
  late Postcode postcode;
  List<Postcode> postcodes = [];
  City? city;
  States? state;

  @override
  void initState() {
    firstNameCT.text = "testD";
    lastNameCT.text = "khind";
    mobileNoCT.text = "0156663229";
    emailCT.text = "testD1.khind@gmail.com";
    dobCT.text = "1990-01-21";
    address1CT.text = "No 44 Taman Murni";
    address2CT.text = "Taman Murni";
    confirmPasswordCT.text = "p455word";
    passwordCT.text = "p455word";
    _init();
    _fetchStates();
    super.initState();
  }

  _init() {
    city = new City(
      stateId: "",
      city: "--Select City--",
      cityId: "",
      postcodeId: "",
      postcode: "",
    );
    state = new States(countryId: "", state: "--Select State--", stateId: "", stateCode: "");
    postcode = new Postcode(id: "", postcode: "--Select--");
  }

  @override
  void dispose() {
    emailCT.dispose();
    firstNameCT.dispose();
    lastNameCT.dispose();
    mobileNoCT.dispose();
    dobCT.dispose();
    passwordCT.dispose();
    confirmPasswordCT.dispose();
    super.dispose();
  }

  _fetchStates() async {
    final response = await Api.bearerGet('provider/state.php', isCms: true);
    var newStates = (response['states'] as List).map((i) => States.fromJson(i)).toList();

    newStates.insert(0, new States(countryId: "", state: "--Select--", stateId: "", stateCode: ""));

    setState(() {
      states = newStates;
      state = newStates[0];
    });
  }

  _fetchCities(stateId) async {
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

  Widget _renderHeader() {
    return Container(
        alignment: Alignment.center,
        child: Image(
            image: AssetImage('assets/images/logo_text.png'),
            height: MediaQuery.of(context).size.width * 0.15));
  }

  Future<void> _selectDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDob,
        firstDate: DateTime(now.year - 100),
        lastDate: DateTime(now.year - 10, 12, 31));
    // print('PICKED: $picked');
    if (picked != null && picked != selectedDob) {
      String fm = '${picked.month}';
      String fd = '${picked.day}';

      if (picked.month < 10) {
        fm = '0${picked.month}';
      }
      if (picked.day < 10) {
        fd = '0${picked.day}';
      }
      setState(() {
        selectedDob = picked;
        dobCT.text = '${picked.year}-$fm-$fd';
      });
    }
  }

  void _clearTextField() {
    emailCT.clear();
    firstNameCT.clear();
    lastNameCT.clear();
    mobileNoCT.clear();
    dobCT.clear();
    passwordCT.clear();
    confirmPasswordCT.clear();
  }

  // _validateToken() async {
  //   String? token = await storage.read(key: TOKEN);

  //   if (token != null) {
  //     return;
  //   } else {
  //     final response = await Api.basicPost('oauth2/token/client_credentials');

  //     if (response['access_token'] != null) {
  //       await storage.write(key: TOKEN, value: response['access_token']);

  //       if (response['expires_in'] != null) {
  //         var curDate = new DateTime.now();
  //         var expDate = curDate.add(Duration(milliseconds: response['expires_in']));

  //         await storage.write(
  //             key: TOKEN_EXPIRY, value: (expDate.millisecondsSinceEpoch).toString());
  //       }
  //     }
  //   }
  // }

  _fetchOauth() async {
    final response = await Api.basicPost('oauth2/token/client_credentials');

    if (response['access_token'] != null) {
      await storage.write(key: TOKEN, value: response['access_token']);

      if (response['expires_in'] != null) {
        var curDate = new DateTime.now();
        var expDate = curDate.add(Duration(milliseconds: response['expires_in']));

        await storage.write(key: TOKEN_EXPIRY, value: (expDate.millisecondsSinceEpoch).toString());
      }
    }
  }

  void _handleSignUp() async {
    Helpers.showAlert(context);
    // if (_formKey.currentState!.validate()) {
    final Map<String, dynamic> map = {
      'email': emailCT.text,
      'firstname': firstNameCT.text,
      'lastname': lastNameCT.text,
      'address_1': address1CT.text,
      'address_2': address2CT.text,
      'postcode': postcode.postcode,
      'city': city?.cityId,
      'zone_id': state?.stateId,
      'country_id': '129',
      'telephone': mobileNoCT.text,
      'password': passwordCT.text,
      'confirm': confirmPasswordCT.text,
      'company': "",
      'tax_id': 0,
      'agree': 1
    };

    // print("#MAPO2O: $map");
    // await _validateToken();
    await _fetchOauth();

    final response = await Api.bearerPost('register_user.php', params: jsonEncode(map));
    setState(() {
      isLoading = true;
      errorMsg = "";
      errors = [];
    });
    Navigator.pop(context);

    if (response['success']) {
      final Map<String, dynamic> mapRest = {
        'first_name': firstNameCT.text,
        'last_name': lastNameCT.text,
        'email': emailCT.text,
        'date_of_birth': dobCT.text,
        'telephone': mobileNoCT.text,
        'address_line1': address1CT.text,
        'address_line2': address2CT.text,
        'zone_id': state?.stateId,
        'city_id': city?.cityId,
        'postcode_id': postcode.id
      };

      // print("#MAP REST: $map");

      final respRest =
          await Api.bearerPost('provider/register_user.php', isCms: true, queryParams: mapRest);
      // print("#RESP REST: ${jsonEncode(response['data'])}");

      if (respRest['success']) {
        await storage.write(key: IS_AUTH, value: "1");
        await storage.write(key: USER, value: jsonEncode(response['data']));
        Helpers.showAlert(context, title: 'You have successfully sign up', hasAction: true,
            onPressed: () async {
          _clearTextField();
          setState(() {
            errors = [];
            agreeTerm = false;
          });
          Navigator.pop(context);

          Navigator.pushReplacementNamed(context, 'home', arguments: 0);
          // Timer(Duration(seconds: 1),
          //     () => Navigator.pushReplacementNamed(context, 'home', arguments: 0));
        });
      } else {
        setState(() {
          isLoading = false;
          errors.add("Internal Server Error!");
        });
      }
    } else {
      if (response['error'] != null) {
        setState(() {
          isLoading = false;
          errorMsg = "Validation failed!";

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
    // } else {
    //   Navigator.pop(context);
    // }
  }

  Widget _renderProfileForm() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Form(
            key: _basicFormKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Step 1 : Fill in your information", style: TextStyles.textSecondaryBold),
              SizedBox(height: 20),
              TextFormField(
                focusNode: focusEmail,
                keyboardType: TextInputType.text,
                validator: (value) {
                  var regExp = RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
                controller: emailCT,
                // onFieldSubmitted: (val) {
                //   FocusScope.of(context).requestFocus(new FocusNode());
                // },
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'E-mail',
                    hintStyle:
                        focusEmail.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              TextFormField(
                focusNode: focusFirstName,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
                controller: firstNameCT,
                // onFieldSubmitted: (val) {
                //   FocusScope.of(context).requestFocus(new FocusNode());
                // },
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'First Name',
                    hintStyle:
                        focusFirstName.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              TextFormField(
                focusNode: focusLastName,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
                controller: lastNameCT,
                // onFieldSubmitted: (val) {
                //   FocusScope.of(context).requestFocus(new FocusNode());
                // },
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'Last Name',
                    hintStyle:
                        focusLastName.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              TextFormField(
                focusNode: focusMobile,
                keyboardType: TextInputType.number,
                validator: (value) {
                  RegExp regExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid mobile number format';
                  }
                  return null;
                },
                controller: mobileNoCT,
                // onFieldSubmitted: (val) {
                //   FocusScope.of(context).requestFocus(new FocusNode());
                // },
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'Mobile Number',
                    hintStyle:
                        focusMobile.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              Stack(children: [
                TextFormField(
                  focusNode: focusDob,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    RegExp regExp =
                        new RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$');
                    if (value!.isEmpty) {
                      return 'Please enter date of birth';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Invalid date format';
                    }
                    return null;
                  },
                  controller: dobCT,
                  // onFieldSubmitted: (val) {
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  // },
                  style: TextStyles.textDefault,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primary, width: 2, style: BorderStyle.solid),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                      ),
                      hintText: 'Date of Birth',
                      hintStyle:
                          focusDob.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
                ),
                Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () => _selectDob(context),
                        icon: Icon(Icons.date_range, size: 25)))
              ]),
              SizedBox(height: 30),
              RoundButton(
                  title: "Next",
                  icon: Icons.arrow_right_alt_rounded,
                  onPressed: () {
                    if (_basicFormKey.currentState!.validate()) {
                      setState(() {
                        showAddressForm = true;
                      });
                    }
                  })
            ])));
  }

  Widget _renderAddressForm() {
    // print("CITY: $cities");
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Form(
            key: _addressFormKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Row(children: [
                InkWell(
                    onTap: () => setState(() {
                          showAddressForm = false;
                          showPwdForm = false;
                        }),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Icon(Icons.arrow_back, color: AppColors.tertiery),
                        decoration: BoxDecoration(
                            color: Colors.grey[300], borderRadius: BorderRadius.circular(20)))),
                SizedBox(width: 20),
                Flexible(
                    child:
                        Text("Step 2 : Fill in your address", style: TextStyles.textSecondaryBold))
              ]),
              SizedBox(height: 20),
              TextFormField(
                focusNode: focusAddress1,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter address 1';
                  }
                  return null;
                },
                controller: address1CT,
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'Address 1',
                    hintStyle:
                        focusAddress1.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              TextFormField(
                focusNode: focusAddress2,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter address 2';
                  }
                  return null;
                },
                controller: address2CT,
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'Address 2',
                    hintStyle:
                        focusAddress2.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              states.length > 0
                  ? DropdownButtonFormField(
                      focusNode: focusState,
                      // onTap: () {
                      //   FocusScope.of(context).requestFocus(focusState);
                      // },
                      style: TextStyles.textDefault,
                      decoration: InputDecoration(
                        labelText: 'State',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primary, width: 2, style: BorderStyle.solid),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.greyLight, width: 1, style: BorderStyle.solid)),
                      ),
                      // dropdownColor: Colors.blueAccent,
                      value: state != null ? state : null,
                      onChanged: (val) {
                        setState(() {
                          cities = [];
                          postcodes = [];
                          city = new City(
                              stateId: "", city: "All", cityId: "", postcodeId: "", postcode: "");
                          // postcode = "";
                          state = (val as States);
                          _fetchCities(val.stateId);
                        });
                      },
                      items: states
                          .map((e) => DropdownMenuItem(
                              child: Text(e.state!), value: e, key: Key(jsonEncode(e))))
                          .toList())
                  : Container(),
              SizedBox(height: 5),
              cities.length > 0
                  ? DropdownButtonFormField(
                      focusNode: focusCity,
                      style: TextStyles.textDefault,
                      decoration: InputDecoration(
                        labelText: 'City',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primary, width: 2, style: BorderStyle.solid),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.greyLight, width: 1, style: BorderStyle.solid)),
                      ),
                      value: city != null ? city : null,
                      onChanged: (val) {
                        setState(() {
                          city = (val as City);
                          // if (val.postcode != null) {
                          //   postcodeCT.text = val.postcode!;
                          //   postcode = val.postcode!;
                          // }
                        });
                      },
                      items: cities
                          .map((e) => DropdownMenuItem(
                              child: Text(e.city!), value: e, key: Key(jsonEncode(e))))
                          .toList())
                  : Container(),
              postcodes.length > 0 ? SizedBox(width: 10) : Container(),
              postcodes.length > 0
                  ? DropdownButtonFormField(
                      focusNode: focusPostcode,
                      style: TextStyles.textDefault,
                      decoration: InputDecoration(
                        labelText: 'Postcode',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primary, width: 2, style: BorderStyle.solid),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.greyLight, width: 1, style: BorderStyle.solid)),
                      ),
                      value: postcode != null ? postcode : null,
                      items: postcodes
                          .map((e) => DropdownMenuItem(
                              child: Text(e.postcode as String),
                              value: e,
                              key: Key(e.id as String)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          postcode = val as Postcode;
                          // this.onSelectCity(value.postcode!);
                        });
                      },
                    )
                  : Container(),
              // TextFormField(
              //   focusNode: focusPostcode,
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     RegExp regExp = new RegExp(r'^(^[0-9]*$)');
              //     if (value!.isEmpty) {
              //       return 'Please enter postcode';
              //     } else if (!regExp.hasMatch(value)) {
              //       return 'Invalid postcode format';
              //     }
              //     return null;
              //   },
              //   controller: postcodeCT,
              //   // onFieldSubmitted: (val) {
              //   //   FocusScope.of(context).requestFocus(new FocusNode());
              //   // },
              //   style: TextStyles.textDefault,
              //   decoration: InputDecoration(
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide:
              //             BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
              //       ),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
              //       ),
              //       hintText: 'Postcode',
              //       hintStyle:
              //           focusPostcode.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
              //       contentPadding: const EdgeInsets.symmetric(vertical: 5),
              //       border: UnderlineInputBorder(
              //           borderSide: BorderSide(
              //               color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              // ),
              SizedBox(height: 30),
              RoundButton(
                  title: "Next",
                  icon: Icons.arrow_right_alt_rounded,
                  onPressed: () {
                    if (_addressFormKey.currentState!.validate()) {
                      setState(() {
                        showPwdForm = true;
                        showAddressForm = false;
                      });
                    }
                  })
            ])));
  }

  Widget _renderPwdForm() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Form(
            key: _pwdFormKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Row(children: [
                InkWell(
                    onTap: () => setState(() {
                          showPwdForm = false;
                          showAddressForm = true;
                        }),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Icon(Icons.arrow_back, color: AppColors.tertiery),
                        decoration: BoxDecoration(
                            color: Colors.grey[300], borderRadius: BorderRadius.circular(20)))),
                SizedBox(width: 20),
                Flexible(
                    child: Text("Step 3 : Create password", style: TextStyles.textSecondaryBold))
              ]),
              SizedBox(height: 20),
              Stack(children: [
                TextFormField(
                  focusNode: focusPwd,
                  keyboardType: TextInputType.text,
                  obscureText: !showPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  controller: passwordCT,
                  // onFieldSubmitted: (val) {
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  // },
                  style: TextStyles.textDefault,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primary, width: 2, style: BorderStyle.solid),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                      ),
                      hintText: 'Password',
                      hintStyle:
                          focusPwd.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
                ),
                Positioned(
                    right: 15,
                    top: 10,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: Icon(showPassword ? Icons.visibility : Icons.visibility_off)))
              ]),
              SizedBox(height: 5),
              Stack(children: [
                TextFormField(
                  focusNode: focusConfirmPwd,
                  keyboardType: TextInputType.text,
                  obscureText: !showConfirmPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != passwordCT.text) {
                      return 'Password does not match with confirm password';
                    }
                    return null;
                  },
                  controller: confirmPasswordCT,
                  // onFieldSubmitted: (val) {
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  // },
                  style: TextStyles.textDefault,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primary, width: 2, style: BorderStyle.solid),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                      ),
                      hintText: 'Retype Password',
                      hintStyle: focusConfirmPwd.hasFocus
                          ? TextStyles.textPrimary
                          : TextStyles.textGreyDark,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
                ),
                Positioned(
                    right: 15,
                    top: 10,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                        child: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off)))
              ]),
              SizedBox(height: 20),
              Container(
                  height: 50,
                  child: InkWell(
                      onTap: () => this.setState(() {
                            this.agreeTerm = !this.agreeTerm;
                          }),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              agreeTerm = !agreeTerm;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: agreeTerm ? AppColors.secondary : Colors.white,
                                border: Border.all(color: AppColors.primary, width: 1)),
                            child: Container(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.check_sharp,
                                  size: 25.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    children: [
                              TextSpan(text: "I have read and agreed to the "),
                              TextSpan(
                                  text: 'Terms of Use',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Helpers.launchInWebViewOrVC(
                                          'https://www.khind.com.my/index.php?route=information/information/info&information_id=8');
                                    },
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))
                            ])))
                      ]))),
              SizedBox(height: 30),
              RoundButton(
                  title: "Sign Up",
                  onPressed: () {
                    print("AGREE TERM: $agreeTerm");
                    if (!agreeTerm) {
                      Helpers.showAlert(context,
                          onPressed: () => {Navigator.pop(context)},
                          hasAction: true,
                          title: "Warning",
                          desc: "You must agree Term of Use!");
                    } else if (_pwdFormKey.currentState!.validate()) {
                      _handleSignUp();
                    }
                  })
            ])));
  }

  _renderError() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: errors
            .map((elem) => Container(
                    child: Text(
                  elem,
                  style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Sign Up", isBack: true, hasActions: false),
      body: CustomPaint(
          painter: BgPainter(hasAppBar: true),
          child: SingleChildScrollView(
              // physics: ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        _renderHeader(),
                        SizedBox(height: errors.length > 0 ? 20 : 50),
                        errors.length > 0 ? _renderError() : Container(),
                        SizedBox(height: errors.length > 0 ? 10 : 0),
                        showAddressForm ? _renderAddressForm() : Container(),
                        showPwdForm ? _renderPwdForm() : Container(),
                        !showAddressForm && !showPwdForm ? _renderProfileForm() : Container()
                        // SizedBox(height: 50)
                      ]))))),
    );
  }
}
