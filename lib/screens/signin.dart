import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  String errorMsg = "";
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    emailCT.text = 'khindcustomerservice@gmail.com';
    passwordCT.text = 'Khindanshin118';
    super.initState();
  }

  @override
  void dispose() {
    emailCT.dispose();
    passwordCT.dispose();
    super.dispose();
  }

  void _fetchOauth() async {
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

  void handleSignIn() async {
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> map = {'email': emailCT.text, 'password': passwordCT.text};
      final response = await Api.bearerPost('login', params: jsonEncode(map));

      setState(() {
        isLoading = true;
        errorMsg = "";
      });

      if (response['error'] != null) {
        if (response['error'].runtimeType == String && response['error'] == 'invalid_token') {
          _fetchOauth();
          final response1 = await Api.bearerPost('login', params: jsonEncode(map));
          Navigator.pop(context);

          if (response1['error'] != null) {
            setState(() {
              isLoading = false;
              errorMsg = response1['error']['warning'] != null
                  ? response1['error']['warning']
                  : "Incorrect credentials";
            });
          } else {
            Navigator.pushReplacementNamed(context, 'home');
          }
        } else {
          setState(() {
            isLoading = false;
            errorMsg = response['error']['warning'] != null
                ? response['error']['warning']
                : "Incorrect credentials";
            Navigator.pop(context);
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, 'home');
      }
    } else {
      Navigator.pop(context);
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
                  hintText: '******',
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
          Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  child: Text("Forgot Password?", textAlign: TextAlign.left),
                  onTap: () => Navigator.pushNamed(context, 'forgot'))),
          SizedBox(height: 30),
          GradientButton(
              height: 40,
              child: Text("Sign In", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () => handleSignIn()),
          SizedBox(height: 50),
          Text("New to Khind?"),
          SizedBox(height: 10),
          GradientButton(
              height: 40,
              child: Text("Activate My E-Warranty", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () {
                Navigator.of(context).pushNamed('ewarranty');
              }),
          SizedBox(height: 15),
          Text("or"),
          SizedBox(height: 15),
          GradientButton(
              height: 40,
              child: Text("Create a new account", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () {
                setState(() {
                  errorMsg = "";
                });
                Navigator.pushNamed(context, 'signup');
              })
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
