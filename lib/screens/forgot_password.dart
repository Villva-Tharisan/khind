import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool success = false;
  String errorMsg = "";
  List errors = [];
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // emailCT.text = 'digit@gmail.com';
    super.initState();
  }

  @override
  void dispose() {
    emailCT.dispose();
    super.dispose();
  }

  void _handleForgotPwd() async {
    Helpers.showAlert(context);

    final Map<String, dynamic> map = {'email': emailCT.text};
    final response = await Api.bearerPost('forgotten', params: jsonEncode(map));

    Navigator.pop(context);

    setState(() {
      success = false;
      isLoading = true;
      errors = [];
    });

    if (response['error'] != null) {
      (response['error'] as List<dynamic>).forEach((elem) {
        errors.add(elem);
      });
    } else {
      Helpers.showAlert(context, hasAction: true, onPressed: () {
        setState(() {
          success = true;
          errors = [];
        });
        Navigator.pop(context);
      },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text("Reset password link has been sent to your email")),
            ],
          ));
    }
  }

  Widget _renderHeader() {
    return Container(
        alignment: Alignment.center,
        child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: MediaQuery.of(context).size.width * 0.2));
  }

  Widget _renderForm() {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Enter your email", style: TextStyle(fontWeight: FontWeight.w500)),
          Text("address", style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 20),
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
          SizedBox(height: 100),
          GradientButton(
              height: 40,
              child: Text("Send me my new password", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () => _handleForgotPwd())
        ]));
  }

  _renderSuccess() {
    return Container(
        alignment: Alignment.center,
        child: Container(
            child: Text(
          "Check out your new password within 12 hours",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        )));
  }

  _renderError() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: errors
            .map((elem) => Container(
                    child: Text(
                  elem,
                  style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.only(bottom: 20, left: 50, right: 50, top: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _renderHeader(),
            SizedBox(height: 50),
            errors.length > 0 ? _renderError() : Container(),
            success ? _renderSuccess() : Container(),
            SizedBox(height: errors.length > 0 || success ? 20 : 0),
            _renderForm(),
            SizedBox(height: 50)
          ])),
    );
  }
}
