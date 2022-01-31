import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/states.dart';
import 'package:khind/models/user.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController oldPasswordCT = new TextEditingController();
  FocusNode focusOldPassword = new FocusNode();
  FocusNode focusPassword = new FocusNode();
  bool isLoading = false;
  User? user;
  String errorMsg = "";
  List errors = [];
  bool showPassword = false;
  bool showOldPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordCT.dispose();
    oldPasswordCT.dispose();
    super.dispose();
  }

  void _clearTextField() {
    passwordCT.clear();
    oldPasswordCT.clear();
  }

  void _handleUpdate() async {
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> map = {
        'password': passwordCT.text,
        'postcode': oldPasswordCT.text
      };

      // print("MAP: $map");
      final response = await Api.bearerPost('change_password.php', params: jsonEncode(map));
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
                    child: Text("Password has been successfully changed")),
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

  Widget _renderExitIcon() {
    return Positioned(
        right: 5,
        top: 5,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(child: Icon(Icons.close, size: 20, color: Colors.white)))));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    const horContentPad = 10.0;

    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Stack(children: [
              _renderExitIcon(),
              Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    child: Container(
                        alignment: Alignment.center,
                        width: width,
                        padding: const EdgeInsets.only(bottom: 10, top: 15),
                        child: Text("CHANGE PASSWORD", style: TextStyles.textSecondaryBold))),
                Divider(color: Colors.grey[300]),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.only(top: 15),
                        //   width: width * 0.30,
                        //   child: Text('Old Password', style: TextStyles.textDefault),
                        // ),
                        // SizedBox(width: 15),
                        Flexible(
                            child: Stack(children: [
                          TextFormField(
                            focusNode: focusOldPassword,
                            keyboardType: TextInputType.text,
                            obscureText: !showOldPassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter old password';
                              }
                              return null;
                            },
                            controller: oldPasswordCT,
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            style: TextStyles.textDefault,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primary, width: 2, style: BorderStyle.solid),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.greyLight,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                hintText: 'Old Password',
                                hintStyle: focusOldPassword.hasFocus
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
                                      showOldPassword = !this.showOldPassword;
                                    });
                                  },
                                  child: Icon(
                                      showOldPassword ? Icons.visibility : Icons.visibility_off)))
                        ])),
                      ],
                    )),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: horContentPad),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.only(top: 15),
                        //   width: width * 0.30,
                        //   child: Text('Password', style: TextStyles.textDefault),
                        // ),
                        // SizedBox(width: 15),
                        Flexible(
                            child: Stack(children: [
                          TextFormField(
                            focusNode: focusPassword,
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
                                      color: AppColors.primary, width: 2, style: BorderStyle.solid),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.greyLight,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                hintText: 'Password',
                                hintStyle: focusOldPassword.hasFocus
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
                                      showPassword = !this.showPassword;
                                    });
                                  },
                                  child:
                                      Icon(showPassword ? Icons.visibility : Icons.visibility_off)))
                        ])),
                      ],
                    )),
                SizedBox(height: 10),
                Container(
                    alignment: Alignment.center,
                    width: width,
                    padding: const EdgeInsets.only(bottom: 10, top: 15),
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                    child: InkWell(
                        // onTap: () => _handleUpdate(),
                        onTap: () => {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text("Update", style: TextStyles.textWhiteBold))))
              ])
            ])));
  }
}
