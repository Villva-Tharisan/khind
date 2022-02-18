import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:khind/components/bg_painter.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  FocusNode focusEmail = new FocusNode();
  FocusNode focusPwd = new FocusNode();
  bool isLoading = false;
  bool showPassword = false;
  String errorMsg = "";
  String version = "";
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    emailCT.text = 'khindtest1@gmail.com';
    passwordCT.text = 'Abcd@1234';
    // emailCT.text = 'khindcustomerservice@gmail.com';
    // passwordCT.text = 'Khindanshin118';

    super.initState();
    _loadVersion();
  }

  @override
  void dispose() {
    emailCT.dispose();
    passwordCT.dispose();
    super.dispose();
  }

  _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String pkgVersion = packageInfo.version;

    setState(() {
      version = pkgVersion;
    });
  }

  void _handleSignIn() async {
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> map = {
        'email': emailCT.text,
        'password': passwordCT.text
      };
      final response = await Api.bearerPost('login', params: jsonEncode(map));

      setState(() {
        isLoading = true;
        errorMsg = "";
      });

      // print("#LOGIN RESP: ${jsonEncode(response)}");

      if (response?.length > 0) {
        if (response['error'] != null) {
          if (response['error'].runtimeType == String &&
              response['error'] == 'invalid_token') {
            setState(() {
              isLoading = false;
              errorMsg = "Token has expired. Please restart the app";
              Navigator.pop(context);
            });
          } else {
            setState(() {
              isLoading = false;
              errorMsg = response['error']['warning'] != null
                  ? response['error']['warning']
                  : "Either server error or incorrect credentials";
              Navigator.pop(context);
            });
          }
        } else {
          await storage.write(key: IS_AUTH, value: "1");
          var newResp = response['data'];
          newResp['email'] = emailCT.text;
          await storage.write(key: USER, value: jsonEncode(newResp));
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'home', arguments: 0);
        }
      } else {
        setState(() {
          isLoading = false;
          errorMsg = "Either server error or incorrect credentials";
          Navigator.pop(context);
        });
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget _renderHeader() {
    return Container(
        alignment: Alignment.center,
        child: Image(
            image: AssetImage('assets/images/logo_text.png'),
            height: MediaQuery.of(context).size.width * 0.15));
  }

  Widget _renderForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Login Account", style: TextStyles.textTitle),
            SizedBox(height: 10),
            TextFormField(
              focusNode: focusEmail,
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
              style: TextStyles.textDefault,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                        style: BorderStyle.solid),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.greyLight,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  hintText: 'E-mail',
                  hintStyle: focusEmail.hasFocus
                      ? TextStyles.textPrimary
                      : TextStyles.textGreyDark,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight,
                          width: 1,
                          style: BorderStyle.solid))),
            ),
            SizedBox(height: 5),
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
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                style: TextStyles.textDefault,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    hintText: 'Password',
                    hintStyle: focusPwd.hasFocus
                        ? TextStyles.textPrimary
                        : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight,
                            width: 1,
                            style: BorderStyle.solid))),
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
                      child: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off)))
            ]),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Text("In case you forgot password?",
                    textAlign: TextAlign.left,
                    style: TextStyles.textSm.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.link)),
                onTap: () => Navigator.pushNamed(context, 'forgot'),
              ),
            ),
            SizedBox(height: 30),
            RoundButton(
                height: 40, title: "Sign In", onPressed: () => _handleSignIn()),
            SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(child: Divider(color: AppColors.greyLight)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text("OR",
                      style: TextStyles.textDefault
                          .copyWith(fontWeight: FontWeight.w500)),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15))),
              Expanded(child: Divider(color: AppColors.greyLight)),
            ]),
            SizedBox(height: 15),
            RoundButton(
              color: AppColors.tertiery,
              title: "Activate My E-Warranty",
              onPressed: () {
                Helpers.fromSignIn = true;
                Navigator.of(context).pushNamed('ewarranty');
              },
            ),
          ],
        ),
      ),
    );
  }

  _renderError() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      // SizedBox(height: 10),
      Text(
        errorMsg,
        style: TextStyle(
            color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20),
    ]);
  }

  _renderBottom() {
    return Column(children: [
      Text("Don't have an account?", style: TextStyles.textDefaultBold),
      SizedBox(height: 10),
      InkWell(
          child: Text("REGISTER",
              style: TextStyles.textSecondaryBold.copyWith(fontSize: 18)),
          onTap: () {
            setState(() {
              errorMsg = "";
            });
            Navigator.pushNamed(context, 'signup');
          })
    ]);
  }

  Widget _renderVersion() {
    return Container(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            text: 'Version ',
            style: TextStyles.textDefault,
            children: <TextSpan>[
              TextSpan(
                  text: version, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
          painter: BgPainter(),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _renderHeader(),
                SizedBox(height: errorMsg != "" ? 20 : 50),
                errorMsg != "" ? _renderError() : Container(),
                _renderForm(),
                SizedBox(height: 30),
                _renderBottom(),
                version != "" ? Spacer() : Container(),
                version != "" ? _renderVersion() : Container()
              ]))),
    );
  }
}
