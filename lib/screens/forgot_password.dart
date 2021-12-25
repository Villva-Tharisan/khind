import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  String errorMsg = "";
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
      isLoading = true;
      errorMsg = "";
    });

    if (response['error'] != null) {
    } else {
      Helpers.showAlert(context, hasAction: true, onPressed: () {
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
          Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  child: Text("Forgot Password?", textAlign: TextAlign.left), onTap: () {})),
          SizedBox(height: 30),
          GradientButton(
              height: 40,
              child: Text("Sign In", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () => _handleForgotPwd())
        ]));
  }

  _renderError() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      // SizedBox(height: 10),
      Text(
        errorMsg,
        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.only(bottom: 20, left: 50, right: 50, top: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            _renderHeader(),
            SizedBox(height: errorMsg != "" ? 20 : 50),
            errorMsg != "" ? _renderError() : Container(),
            _renderForm(),
            SizedBox(height: 50)
          ])),
    );
  }
}
