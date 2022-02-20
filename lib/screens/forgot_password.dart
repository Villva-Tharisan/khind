import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/bg_painter.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  FocusNode focusEmail = new FocusNode();
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

  void _handleUpdate() async {
    Helpers.showAlert(context);

    final Map<String, dynamic> map = {'email': emailCT.text};
    final response = await Api.bearerPost('forgotten', params: jsonEncode(map));
    print("#RESP: ${jsonEncode(response)}");
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
      Helpers.showAlert(context,
          title: "Check out your new password at your email", hasAction: true, onPressed: () {
        setState(() {
          success = true;
          errors = [];
          emailCT.text = "";
        });
        Navigator.of(context).pop();
        // Navigator.of(context)
        //   ..pop()
        //   ..pop();
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

  Widget _renderForm() {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Enter your email", style: TextStyle(fontWeight: FontWeight.w500)),
              Text("address", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
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
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.greyLight, width: 1, style: BorderStyle.solid),
                    ),
                    hintText: 'Eg: khind@gmail.com',
                    hintStyle:
                        focusEmail.hasFocus ? TextStyles.textPrimary : TextStyles.textGreyDark,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.greyLight, width: 1, style: BorderStyle.solid))),
              ),
              SizedBox(height: 40),
              RoundButton(
                  // height: 40,
                  title: 'Send me my new password',
                  onPressed: () => _handleUpdate()),
              SizedBox(height: 10),
              RoundButton(
                  color: AppColors.tertiery,
                  // height: 40,
                  title: 'Back to Login screen',
                  onPressed: () => Navigator.pop(context)),
            ])));
  }

  // _renderSuccess() {
  //   return Container(
  //       alignment: Alignment.center,
  //       child: Container(
  //           child: Text(
  //         "Check out your new password at your email",
  //         style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500),
  //         textAlign: TextAlign.center,
  //       )));
  // }

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
      key: _scaffoldKey,
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "Forgot Password", isBack: true, hasActions: false),
      body: CustomPaint(
          painter: BgPainter(),
          child: Container(
              padding: const EdgeInsets.only(bottom: 20, left: 50, right: 50, top: 10),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                _renderHeader(),
                SizedBox(height: 50),
                errors.length > 0 ? _renderError() : Container(),
                // success ? _renderSuccess() : Container(),
                SizedBox(height: errors.length > 0 || success ? 20 : 0),
                _renderForm(),
                SizedBox(height: 50)
              ]))),
    );
  }
}
