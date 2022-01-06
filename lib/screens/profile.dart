import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/user.dart';
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
  TextEditingController mobileNoCT = new TextEditingController();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController addressCT = new TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  User? user;
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

    setState(() {
      user = User.fromJson({
        'id': "1",
        'name': 'Khind',
        'email': 'khindcustomerservice@gmail.com',
        'address': 'Nu Sentral'
      });
    });
  }

  @override
  void dispose() {
    emailCT.dispose();
    mobileNoCT.dispose();
    passwordCT.dispose();
    addressCT.dispose();
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
        // dobCT.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  void _clearTextField() {
    emailCT.clear();
    mobileNoCT.clear();
    passwordCT.clear();
    addressCT.clear();
  }

  void _handleUpdate() async {
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> map = {
        'email': emailCT.text,
        'password': passwordCT.text,
        'telephone': mobileNoCT.text,
        'address': addressCT.text
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
    return Container(height: 1, color: Colors.grey[300], width: double.infinity);
  }

  Widget _renderLabel(title) {
    return Container(width: MediaQuery.of(context).size.width * 0.25, child: Text(title));
  }

  Widget _renderItemContainer(child) {
    return Container(padding: const EdgeInsets.only(right: 10), child: child);
  }

  Widget _renderEditBtn(name) {
    return InkWell(
        onTap: () {},
        child: Container(
            decoration: BoxDecoration(color: AppColors.primary),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text("Edit")));
  }

  Widget _renderForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(left: 20),
              child: Column(children: [
                SizedBox(height: 20),
                _renderItemContainer(Row(children: [
                  _renderLabel("Name"),
                  SizedBox(width: 10),
                  Flexible(
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15), child: Text(user!.name)))
                ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                _renderItemContainer(Row(children: [
                  _renderLabel("Mobile"),
                  Flexible(
                      child: TextFormField(
                          keyboardType: TextInputType.text,
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
                          onFieldSubmitted: (val) {},
                          decoration: InputDecoration(
                            suffixIcon: _renderEditBtn('mobile'),
                            border: InputBorder.none,
                            hintText: 'eg: 0123456789',
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          )))
                ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                _renderItemContainer(Row(children: [
                  _renderLabel("Email"),
                  Flexible(
                      child: TextFormField(
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
                    onFieldSubmitted: (val) {},
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'eg: khind@gmail.com',
                        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                  ))
                ])),
                SizedBox(height: 5),
                _renderDivider(),
                SizedBox(height: 10),
                _renderItemContainer(Row(children: [
                  _renderLabel("D.O.B"),
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
                      // controller: dobCT,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'dd-mm-yyyy',
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
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
                _renderItemContainer(Row(children: [
                  _renderLabel("Password"),
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
                          hintText: '******',
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
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
                  ]))
                ])),
                SizedBox(height: 5),
                _renderDivider()
              ])),
          Expanded(child: Container()),
          RoundButton(
              title: 'Sign Out',
              height: MediaQuery.of(context).size.height * 0.08,
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
