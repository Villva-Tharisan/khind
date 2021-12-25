import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  Widget _renderHeader() {
    return Container(
        alignment: Alignment.center,
        child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: MediaQuery.of(context).size.width * 0.2));
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
      final response = await Api.bearerPost('register_user.php', params: jsonEncode(map));
      setState(() {
        isLoading = true;
        errorMsg = "";
        errors = [];
      });
      Navigator.pop(context);

      if (response['success']) {
        Helpers.showAlert(context, hasAction: true, onPressed: () {
          _clearTextField();
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'home');
        },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5), child: Text("You have successfully sign up")),
              ],
            ));
      } else {
        // print("ERROR: ${response['error']}");
        if (response['error'] != null) {
          setState(() {
            isLoading = false;
            errorMsg = "Validation failed!";

            if (response['error'] is LinkedHashMap) {
              // print("response['error']?.runtimeType: ${response['error']?.runtimeType}");

              (response['error'] as LinkedHashMap).forEach((key, value) {
                print('$key | $value');
                errors.add(value);
              });
            }
          });
        } else {
          setState(() {
            isLoading = false;
            // errorMsg = "Validation failed!";
            errors.add("Validation failed!");
          });
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  Widget _renderForm() {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          TextFormField(
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
                hintText: 'eg: khind@gmail.com',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
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
                hintText: 'First Name',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
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
                hintText: 'Last Name',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
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
                hintText: 'Mobile Number',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          Stack(children: [
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
                  hintText: 'Date of Birth',
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5))),
            ),
            Positioned(
                right: 0,
                child: IconButton(
                    onPressed: () => _selectDob(context), icon: Icon(Icons.date_range, size: 25)))
          ]),
          SizedBox(height: 5),
          Stack(children: [
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
                  hintText: 'Password',
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5))),
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
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                  hintText: 'Retype Password',
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5))),
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
          GradientButton(
              height: 40,
              child: Text("Sign Up", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () => _handleSignUp())
        ]));
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
      appBar: AppBar(
          backgroundColor: Colors.grey[300]!,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.grey[500],
              size: 40,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Sign Up", style: TextStyle(color: Colors.black)),
          titleSpacing: -10),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(bottom: 20, left: 50, right: 50, top: 10),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(height: 20),
                _renderHeader(),
                SizedBox(height: errors.length > 0 ? 20 : 50),
                errors.length > 0 ? _renderError() : Container(),
                SizedBox(height: errors.length > 0 ? 10 : 0),
                _renderForm(),
                // SizedBox(height: 50)
              ]))),
    );
  }
}
