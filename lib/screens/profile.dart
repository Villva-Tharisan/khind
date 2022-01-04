import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController firstNameCT = new TextEditingController();
  TextEditingController lastNameCT = new TextEditingController();
  TextEditingController mobileNoCT = new TextEditingController();
  TextEditingController dobCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController confirmPasswordCT = new TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String errorMsg = "";
  List errors = [];
  DateTime now = DateTime.now();
  DateTime selectedDob = DateTime(DateTime.now().year - 10);
  final textStyle = TextStyle(fontSize: 14);

  @override
  void initState() {
    // firstNameCT.text = "test";
    // lastNameCT.text = "khind";
    // mobileNoCT.text = "0156663229";
    // emailCT.text = "test.khind@gmail.com";
    // passwordCT.text = "p455word";
    // dobCT.text = "01-01-1990";
    // confirmPasswordCT.text = "p455word";
    super.initState();
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

  void _handleSignUp() async {
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> map = {
        'email': emailCT.text,
        'firstname': firstNameCT.text,
        'lastname': lastNameCT.text,
        'password': passwordCT.text,
        'telephone': mobileNoCT.text,
        'confirm': confirmPasswordCT.text,
        'agree': 1
      };

      // print("MAP: $map");
      final response = await Api.bearerPost('update_user.php', params: jsonEncode(map));
      setState(() {
        isLoading = true;
        errorMsg = "";
        errors = [];
      });
      Navigator.pop(context);

      if (response['success']) {
        Helpers.showAlert(context, hasAction: true, onPressed: () {
          _clearTextField();
          setState(() {
            errors = [];
          });
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'home');
        },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text("Your profile has been successfully updated")),
              ],
            ));
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
    } else {
      Navigator.pop(context);
    }
  }

  Widget _renderDivider() {
    return Container(height: 1, color: Colors.grey, width: double.infinity);
  }

  Widget _renderForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("Name"),
                      SizedBox(width: 10),
                      Flexible(
                          child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        controller: emailCT,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: khind@gmail.com',
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                      )),
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("Name"),
                      SizedBox(width: 10),
                      Flexible(
                          child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        controller: firstNameCT,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name',
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        ),
                      ))
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("Name"),
                      SizedBox(width: 10),
                      Flexible(
                          child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        controller: lastNameCT,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Last Name',
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                      ))
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("Name"),
                      SizedBox(width: 10),
                      Flexible(
                          child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                        controller: mobileNoCT,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mobile Number',
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                      ))
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("D.O.B"),
                      SizedBox(width: 10),
                      Flexible(
                          child: Stack(children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter date of birth';
                            }
                            return null;
                          },
                          controller: dobCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'dd-mm-yyyy',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                        ),
                        Positioned(
                            right: 0,
                            child: IconButton(
                                onPressed: () => _selectDob(context),
                                icon: Icon(Icons.date_range, size: 25)))
                      ]))
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("Password"),
                      SizedBox(width: 10),
                      Flexible(
                          child: Stack(children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: !showPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          controller: passwordCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
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
                                child:
                                    Icon(showPassword ? Icons.visibility : Icons.visibility_off)))
                      ]))
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(children: [
                      Text("Address"),
                      SizedBox(width: 10),
                      Flexible(
                          child: Stack(children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: !showConfirmPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          controller: confirmPasswordCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Address',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
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
                                child: Icon(
                                    showConfirmPassword ? Icons.visibility : Icons.visibility_off)))
                      ]))
                    ])),
                SizedBox(height: 5),
                _renderDivider(),
              ])),
          Expanded(child: Container()),
          RoundButton(
              title: 'Sign Out',
              height: MediaQuery.of(context).size.height * 0.1,
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(0),
              titleStyles: TextStyles.textPrimaryBold.copyWith(fontSize: 18),
              onPressed: () async {
                Helpers.showAlert(context,
                    okTitle: "Yes",
                    noTitle: "No",
                    title: "Sign out confirmation",
                    desc: "Are you sure to sign out?",
                    hasAction: true,
                    hasCancel: true, onPressed: () async {
                  await Api.bearerPost('logout');
                  await storage.delete(key: IS_AUTH);

                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, 'signin', (route) => false);
                });
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "My Profile", isBack: true, hasActions: false),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderForm(),
        )
      ]),
    );
  }
}
