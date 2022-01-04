import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:khind/components/bg_painter.dart';
import 'package:khind/components/round_button.dart';
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
  late List<States> states = [];
  late List<City> cities = [];
  City? city;
  States? state;
  String? postcode;

  @override
  void initState() {
    // firstNameCT.text = "test1";
    // lastNameCT.text = "khind";
    // mobileNoCT.text = "0156663229";
    // emailCT.text = "test1.khind@gmail.com";
    // dobCT.text = "01-01-1990";
    // address1CT.text = "No 44 Taman Miharja";
    // confirmPasswordCT.text = "p455word";
    // passwordCT.text = "p455word";
    super.initState();
    _fetchStates();
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

    if (response['states'] != null) {
      setState(() {
        states = (response['states'] as List<dynamic>).map((e) => States.fromJson(e)).toList();
      });
    }
  }

  _fetchCity(stateId) async {
    setState(() {
      city = null;
      cities = [];
    });
    Map<String, dynamic> map = {'state_id': stateId};
    final response = await Api.bearerGet('provider/city.php', params: map, isCms: true);
    // print(response);
    if (response['city'] != null) {
      setState(() {
        cities = (response['city'] as List<dynamic>).map((e) => City.fromJson(e)).toList();
      });
    }
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
      setState(() {
        selectedDob = picked;
        dobCT.text = '${picked.day}-${picked.month}-${picked.year}';
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

  validateToken() async {
    String? token = await storage.read(key: TOKEN);

    if (token != null) {
      return;
    } else {
      final response = await Api.basicPost('oauth2/token/client_credentials');

      if (response['access_token'] != null) {
        await storage.write(key: TOKEN, value: response['access_token']);

        if (response['expires_in'] != null) {
          var curDate = new DateTime.now();
          var expDate = curDate.add(Duration(milliseconds: response['expires_in']));

          await storage.write(
              key: TOKEN_EXPIRY, value: (expDate.millisecondsSinceEpoch).toString());
        }
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
      'postcode': postcode,
      'city': city?.cityId,
      'zone_id': state?.stateId,
      'country_id': 'Malaysia',
      'telephone': mobileNoCT.text,
      'password': passwordCT.text,
      'confirm': confirmPasswordCT.text,
      'agree': 1
    };

    // print("MAP: $map");
    await validateToken();

    final response = await Api.bearerPost('register_user.php', params: jsonEncode(map));
    setState(() {
      isLoading = true;
      errorMsg = "";
      errors = [];
    });
    Navigator.pop(context);

    if (response['success']) {
      Helpers.showAlert(context, title: 'You have successfully sign up', hasAction: true,
          onPressed: () {
        _clearTextField();
        setState(() {
          errors = [];
        });
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home');
      });
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
          errors.add("Validation failed!");
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
                    RegExp regExp = new RegExp(
                        r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');
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
                    return 'Please enter address';
                  }
                  return null;
                },
                controller: address1CT,
                // onFieldSubmitted: (val) {
                //   print("onFieldSubmitted");
                //   FocusScope.of(context).unfocus();
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
                    hintText: 'Address',
                    hintStyle:
                        focusAddress1.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 5),
              states.length > 0
                  ? DropdownButtonFormField(
                      hint: Text("Select state"),
                      focusNode: focusState,
                      // onTap: () {
                      //   FocusScope.of(context).requestFocus(focusState);
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
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.greyLight, width: 1, style: BorderStyle.solid)),
                      ),
                      // dropdownColor: Colors.blueAccent,
                      value: state != null ? state : null,
                      onChanged: (val) {
                        setState(() {
                          state = (val as States);
                          _fetchCity(val.stateId);
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
                      hint: Text("Select city"),
                      focusNode: focusCity,
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
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.greyLight, width: 1, style: BorderStyle.solid)),
                      ),
                      value: city != null ? city : null,
                      onChanged: (val) {
                        setState(() {
                          city = (val as City);
                          if (val.postcode != null) {
                            postcodeCT.text = val.postcode!;
                            postcode = val.postcode!;
                          }
                        });
                      },
                      items: cities
                          .map((e) => DropdownMenuItem(
                              child: Text(e.city!), value: e, key: Key(jsonEncode(e))))
                          .toList())
                  : Container(),
              TextFormField(
                focusNode: focusPostcode,
                keyboardType: TextInputType.number,
                validator: (value) {
                  RegExp regExp = new RegExp(r'^(^[0-9]*$)');
                  if (value!.isEmpty) {
                    return 'Please enter postcode';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid postcode format';
                  }
                  return null;
                },
                controller: postcodeCT,
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
                    hintText: 'Postcode',
                    hintStyle:
                        focusPostcode.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
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
              SizedBox(height: 30),
              RoundButton(
                  title: "Sign Up",
                  onPressed: () {
                    if (_pwdFormKey.currentState!.validate()) {
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
