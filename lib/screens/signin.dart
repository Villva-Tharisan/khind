import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
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
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    fetchToken();
    super.initState();
  }

  @override
  void dispose() {
    emailCT.dispose();
    passwordCT.dispose();
    super.dispose();
  }

  void fetchToken() async {
    String? tokenExp = await storage.read(key: TOKEN_EXPIRY);

    if (tokenExp != null) {
      var expDate = DateTime.fromMillisecondsSinceEpoch(int.parse(tokenExp));

      // print('DIFF: ${expDate.difference(DateTime.now()).inSeconds}');

      if (expDate.difference(DateTime.now()).inSeconds <= 0) {
        print("Token Expired: $expDate");
        final response = await Api.post('oauth2/token/client_credentials');

        if (response['access_token'] != null) {
          await storage.write(key: TOKEN, value: response['access_token']);

          if (response['expires_in'] != null) {
            int expInDays = (response['expires_in'] / 86400).floor();

            var curDate = new DateTime.now();
            var expDate = curDate.add(Duration(days: expInDays));

            await storage.write(
                key: TOKEN_EXPIRY, value: (expDate.millisecondsSinceEpoch).toString());
          }
        }
      } else {
        print("Token Not Expired");
      }
    } else {
      final response = await Api.post('oauth2/token/client_credentials');

      if (response['access_token'] != null) {
        await storage.write(key: TOKEN, value: response['access_token']);

        if (response['expires_in'] != null) {
          int expInDays = (response['expires_in'] / 86400).floor();

          var curDate = new DateTime.now();
          var expDate = curDate.add(Duration(days: expInDays));

          await storage.write(
              key: TOKEN_EXPIRY, value: (expDate.millisecondsSinceEpoch).toString());
        }
      }
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
                  child: Text("Forgot Password?", textAlign: TextAlign.left), onTap: () {})),
          SizedBox(height: 30),
          GradientButton(
              height: 40,
              child: Text("Sign In", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () {}),
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
                Navigator.pushNamed(context, 'signup');
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.only(bottom: 20, left: 50, right: 50, top: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            _renderHeader(),
            SizedBox(height: 50),
            _renderForm(),
            SizedBox(height: 50)
          ])),
    );
  }
}
