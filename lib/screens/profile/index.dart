import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/shipping_address.dart';
import 'package:khind/models/states.dart';
import 'package:khind/screens/profile/change_password.dart';
import 'package:khind/screens/profile/update_address.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/user.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Profile extends StatefulWidget {
  int? data = 0;
  Profile({this.data});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final toolTipKey = GlobalKey<State<Tooltip>>();
  final storage = new FlutterSecureStorage();
  TextEditingController nameCT = new TextEditingController();
  TextEditingController mobileNoCT = new TextEditingController();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController dobCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController postCodeCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  FocusNode focusName = new FocusNode();
  FocusNode focusMobile = new FocusNode();
  FocusNode focusDob = new FocusNode();
  bool isLoading = false;
  // User? user;
  String errorMsg = "";
  List errors = [];
  DateTime now = DateTime.now();
  DateTime selectedDob = DateTime(DateTime.now().year - 10);
  final textStyle = TextStyle(fontSize: 14);
  bool canEditName = false;
  bool canEditMobile = false;
  bool canEditEmail = false;
  bool canEditDob = false;
  bool canEditAddress = false;
  String postcode = "";
  String version = "";
  String buildNo = "";
  ShippingAddress? consumerAddress;
  String? token;
  User? user;

  @override
  void initState() {
    _loadUser();
    _loadVersion();
    _loadToken();
    _fetchConsumerAddress();
    super.initState();
  }

  _loadToken() async {
    final accessToken = await storage.read(key: TOKEN);

    setState(() {
      token = accessToken;
    });
  }

  Future<void> _fetchConsumerAddress() async {
    final response = await Api.bearerGet('shippingaddress');
    print("#fetchConsumerAddress RESPONSE: $response");
    ShippingAddress? newAddress;

    if (response['data'] != null) {
      var shipAddress =
          (response['data']['addresses'] as List).map((i) => ShippingAddress.fromJson(i)).toList();

      // print("CONSUMER ADDRESS: ${response['data']}");

      if (response['data']['address_id'] != null) {
        shipAddress.forEach((elem) {
          if (response['data']['address_id'] == elem.addressId) {
            newAddress = elem;
          }
        });

        // print("CONSUMER ADDRESS: ${newAddress}");

        setState(() {
          consumerAddress = newAddress;
        });
      }
    }
  }

  _loadUser() async {
    var userStorage = await storage.read(key: USER);

    if (userStorage != null) {
      User userJson = User.fromJson(jsonDecode(userStorage));

      print("##USERJSON: ${jsonEncode(userJson)}");

      setState(() {
        user = userJson;

        if (userJson.firstname != null) {
          String nameStr = userJson.firstname!;

          if (userJson.lastname != null) {
            nameStr += ' ${userJson.lastname}';
          }
          nameCT.text = nameStr;
        }

        if (userJson.telephone != null) {
          mobileNoCT.text = userJson.telephone!;
        }

        if (userJson.email != null) {
          emailCT.text = userJson.email!;
        }

        if (userJson.dob != null) {
          dobCT.text = userJson.dob!;
        }
      });
      // print("###USER: ${jsonEncode(user)}");
    }
  }

  _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String pkgVersion = packageInfo.version;
    String pkgBuild = packageInfo.buildNumber;

    setState(() {
      version = pkgVersion;
      buildNo = pkgBuild;
    });
  }

  @override
  void dispose() {
    emailCT.dispose();
    mobileNoCT.dispose();
    address1CT.dispose();
    address2CT.dispose();
    focusName.dispose();
    focusMobile.dispose();
    focusDob.dispose();
    super.dispose();
  }

  // void _clearTextField() {
  //   emailCT.clear();
  //   mobileNoCT.clear();
  //   passwordCT.clear();
  //   address1CT.clear();
  //   address2CT.clear();
  // }

  void _handleUpdate({String field = 'Info'}) async {
    // print("#handleUpdate");
    Helpers.showAlert(context);
    // if (_formKey.currentState!.validate()) {
    Map<String, dynamic> mapName = {};
    // Map<String, dynamic> tempMap = {};
    if (field == 'Name') {
      if (nameCT.text.contains(" ")) {
        mapName = {
          "o2o": {
            'firstname': nameCT.text.substring(0, nameCT.text.indexOf(" ")),
            'lastname': nameCT.text.substring(nameCT.text.indexOf(" ") + 1, nameCT.text.length),
          },
          "rest": {
            'first_name': nameCT.text.substring(0, nameCT.text.indexOf(" ")),
            'last_name': nameCT.text.substring(nameCT.text.indexOf(" ") + 1, nameCT.text.length)
          }
        };
      } else {
        mapName = {
          "o2o": {'firstname': nameCT.text},
          "rest": {'first_name': nameCT.text}
        };
      }
    } else {
      mapName = {
        "o2o": {
          'firstname': user?.firstname,
          'lastname': user?.lastname,
        },
        "rest": {'first_name': user?.firstname, 'last_name': user?.lastname}
      };
    }

    final Map<String, dynamic> mapO2O = {
      ...mapName['o2o'],
      'telephone': mobileNoCT.text,
      'dob': dobCT.text,
      'email': user?.email
    };

    final Map<String, dynamic> map = {
      ...mapName['rest'],
      'telephone': mobileNoCT.text,
      'email': user?.email,
      'date_of_birth': dobCT.text,
      'dob': dobCT.text,
      // 'address_line_1': consumerAddress?.address1,
      // 'address_line_2': consumerAddress?.address2,
      // 'city_id': consumerAddress?.city,
      // 'postcode_id': consumerAddress?.postcode,
      'token': token,
      'platform': Platform.isAndroid ? 'Android' : 'iOS'
    };

    print("#MAP: $map | #MAPO2O  :$mapO2O | USER: ${jsonEncode(user)}");

    final respO2O = await Api.customPut(
      'customers/${user?.id}',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-Oc-Restadmin-Id': FlutterConfig.get("CLIENT_PASSWORD")
      },
      params: jsonEncode(mapO2O),
    );
    setState(() {
      isLoading = true;
      errorMsg = "";
      errors = [];
    });
    Navigator.pop(context);
    // print("#RESPO2O: ${jsonEncode(respO2O)}");
    if (respO2O != null && respO2O['success']) {
      final respRest =
          await Api.bearerPost('provider/register_user.php', queryParams: map, isCms: true);
      print("#RESP: $respRest");
      // if (respRest != null && respRest['success']) {
      if (respRest != null) {
        Helpers.showAlert(context, title: '$field successfully updated', hasAction: true,
            onPressed: () async {
          // _clearTextField();
          var newUser = jsonEncode({...user!.toJson(), ...map});
          // print('#NEWUSER: ${newUser}');
          await storage.write(key: USER, value: newUser);
          setState(() {
            errors = [];
          });
          Navigator.pop(context);
        });
      }
    } else {
      if (respO2O['error'] != null) {
        setState(() {
          isLoading = false;
          errorMsg = "Internal Server Error!";

          if (respO2O['error'] is LinkedHashMap) {
            (respO2O['error'] as LinkedHashMap).forEach((key, value) {
              errors.add(value);
            });
          }
          _showSnackBar();
        });
      } else {
        setState(() {
          isLoading = false;
          errors.add("Internal Server Error!");
          _showSnackBar();
        });
      }
    }
    // } else {
    //   Navigator.pop(context);
    // }
  }

  void _showSnackBar({defaultMsg = 'Internal Server Error'}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: errors.length > 0
            ? Container(
                height: 50,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: errors.map((e) => Text(e)).toList()))
            : Text(defaultMsg),
        duration: const Duration(milliseconds: 5000),
        // width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Future<void> _selectDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDob,
        firstDate: DateTime(now.year - 100),
        lastDate: DateTime(now.year - 10, 12, 31));
    // print('PICKED: $picked');
    if (picked != null && picked != selectedDob) {
      String fm = '${picked.month}';
      String fd = '${picked.day}';

      if (picked.month < 10) {
        fm = '0${picked.month}';
      }
      if (picked.day < 10) {
        fd = '0${picked.day}';
      }
      setState(() {
        if (!this.canEditDob) {
          canEditDob = !this.canEditDob;
        }

        selectedDob = picked;
        dobCT.text = '$fd/$fm/${picked.year}';
      });
    }
  }

  Widget _renderDivider() {
    return Container(height: 1, color: Colors.grey[300], width: double.infinity);
  }

  Widget _renderItemContainer(child, {align, padding}) {
    return Container(
        alignment: align != null ? align : Alignment.center,
        padding: padding != null ? padding : const EdgeInsets.only(right: 10, top: 0, bottom: 0),
        child: child);
  }

  Widget _renderIcon(IconData icon, {onPressed}) {
    return IconButton(onPressed: onPressed, icon: Icon(icon, size: 20, color: Colors.black));
  }

  Widget _renderLabel(title, {width, padding, TextAlign? textAlign, textStyle}) {
    return Container(
        padding: padding != null ? padding : EdgeInsets.all(0),
        width: width != null ? width : MediaQuery.of(context).size.width * 0.25,
        child: Text(title,
            textAlign: textAlign != null ? textAlign : TextAlign.start,
            style: textStyle != null ? textStyle : TextStyles.textDefault));
  }

  Widget _renderField({val}) {
    if (val == null || val == "") {
      return Container(padding: const EdgeInsets.only(top: 25, bottom: 20));
    }
    return Flexible(
        child: Container(padding: const EdgeInsets.only(top: 25, bottom: 20), child: Text('$val')));
  }

  Widget _renderForm() {
    // print("#USER: ${user}");

    double fieldSize = MediaQuery.of(context).size.width * 0.5;
    double screenSize = MediaQuery.of(context).size.width;

    return Form(
        key: _formKey,
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    _renderItemContainer(Row(children: [
                      _renderLabel("Name", textStyle: TextStyles.textDefault),
                      // _renderField(val: '${user?.firstname} ${user?.lastname}')
                      Flexible(
                          child: Row(children: [
                        Container(
                            width: fieldSize,
                            child: TextFormField(
                                // autofocus: true,
                                focusNode: focusName,
                                enabled: canEditName,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: nameCT,
                                onFieldSubmitted: (val) {},
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ))),
                        Spacer(),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                canEditName = !this.canEditName;
                              });
                              print('#canEditName: $canEditName');
                              if (!canEditName) {
                                _handleUpdate(field: 'Name');
                              } else {
                                focusName.unfocus();
                                await Future<void>.delayed(Duration(milliseconds: 1));
                                FocusScope.of(context).requestFocus(focusName);
                              }
                            },
                            child: canEditName
                                ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Icon(Icons.check, color: Colors.green))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text("Edit", style: TextStyles.textDefaultSm)))
                      ]))
                    ])),
                    SizedBox(height: 5),
                    _renderDivider(),
                    SizedBox(height: 10),
                    _renderItemContainer(Row(children: [
                      _renderLabel("Mobile", textStyle: TextStyles.textDefault),
                      Flexible(
                          child: Row(children: [
                        Container(
                            width: fieldSize,
                            child: TextFormField(
                                focusNode: focusMobile,
                                enabled: canEditMobile,
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
                                  border: InputBorder.none,
                                  hintText: 'eg: 0123456789',
                                ))),
                        Spacer(),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                canEditMobile = !this.canEditMobile;
                              });
                              print(canEditMobile);
                              if (!canEditMobile) {
                                _handleUpdate(field: 'Mobile');
                              } else {
                                focusMobile.unfocus();
                                await Future<void>.delayed(Duration(milliseconds: 1));
                                FocusScope.of(context).requestFocus(focusMobile);
                              }
                            },
                            child: canEditMobile
                                ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Icon(Icons.check, color: Colors.green))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text("Edit", style: TextStyles.textDefaultSm)))
                      ]))
                    ])),
                    SizedBox(height: 5),
                    _renderDivider(),
                    SizedBox(height: 10),
                    _renderItemContainer(Row(children: [
                      _renderLabel("Email Address", textStyle: TextStyles.textDefault),
                      Flexible(
                          child: Row(children: [
                        Container(
                            width: fieldSize,
                            child: TextFormField(
                              controller: emailCT,
                              enabled: false,
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
                              onFieldSubmitted: (val) {},
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: 'eg: khind@gmail.com'),
                            ))
                      ]))
                    ])),
                    SizedBox(height: 5),
                    _renderDivider(),
                    SizedBox(height: 10),
                    _renderItemContainer(Row(children: [
                      _renderLabel("D.O.B", textStyle: TextStyles.textDefault),
                      Flexible(
                          child: Stack(children: [
                        TextFormField(
                          focusNode: focusDob,
                          controller: dobCT,
                          enabled: canEditDob,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            RegExp regExp = new RegExp(
                                r'^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$');
                            if (value!.isEmpty) {
                              return 'Please enter date of birth';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Invalid date format';
                            }
                            return null;
                          },
                          // controller: dobCT,
                          onFieldSubmitted: (val) {},
                          decoration:
                              InputDecoration(border: InputBorder.none, hintText: 'dd-mm-yyyy'),
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Row(children: [
                              _renderIcon(Icons.date_range, onPressed: () => _selectDob(context)),
                              InkWell(
                                  onTap: () async {
                                    setState(() {
                                      canEditDob = !this.canEditDob;
                                    });
                                    if (!canEditDob) {
                                      _handleUpdate(field: 'D.O.B');
                                    } else {
                                      focusDob.unfocus();
                                      await Future<void>.delayed(Duration(milliseconds: 1));
                                      FocusScope.of(context).requestFocus(focusDob);
                                    }
                                  },
                                  child: canEditDob
                                      ? Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Icon(Icons.check, color: Colors.green))
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(10)),
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Text("Edit", style: TextStyles.textDefaultSm)))
                            ]))
                      ]))
                    ])),
                    SizedBox(height: 5),
                    _renderDivider(),
                    SizedBox(height: 20),
                    _renderItemContainer(
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Container(
                              width: screenSize * 0.4,
                              height: 40,
                              child: InkWell(
                                  onTap: () => {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext ctx) {
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: UpdateAddress(
                                                      user: user,
                                                      consumerAddress: consumerAddress));
                                            })
                                      },
                                  child: CustomCard(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primary,
                                      child: Text("Update Address",
                                          textAlign: TextAlign.center,
                                          style: TextStyles.textDefaultBoldSm)))),
                          Container(
                              width: screenSize * 0.4,
                              height: 40,
                              child: InkWell(
                                  onTap: () => {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext ctx) {
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: ChangePassword(user: user));
                                            })
                                      },
                                  child: CustomCard(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primary,
                                      child: Text("Change Password",
                                          textAlign: TextAlign.center,
                                          style: TextStyles.textDefaultBoldSm)))),
                        ]),
                        padding: const EdgeInsets.all(0)),
                    SizedBox(height: 20),
                    _renderDivider(),
                    SizedBox(height: 30),
                    _renderItemContainer(
                        InkWell(
                            onTap: () => {
                                  Helpers.launchInWebViewOrVC(
                                      'https://www.khind.com.my/our-team.html')
                                },
                            child: _renderLabel("About Us",
                                padding: EdgeInsets.only(top: 10),
                                textStyle:
                                    TextStyles.textLink.copyWith(fontWeight: FontWeight.w500))),
                        align: Alignment.bottomLeft),
                    SizedBox(height: 20),
                    _renderDivider(),
                    SizedBox(height: 30),
                    _renderItemContainer(
                        InkWell(
                            onTap: () => {
                                  Helpers.launchInWebViewOrVC(
                                      'https://www.khind.com.my/terms-of-use.html')
                                },
                            child: _renderLabel("Term of Use",
                                padding: EdgeInsets.only(top: 10),
                                textStyle:
                                    TextStyles.textLink.copyWith(fontWeight: FontWeight.w500))),
                        align: Alignment.bottomLeft),
                    SizedBox(height: 20),
                    _renderDivider(),
                    SizedBox(height: 30),
                    _renderItemContainer(
                        Row(children: [
                          InkWell(
                              onTap: () => {},
                              child: _renderLabel("App Version",
                                  textStyle: TextStyles.textGrey,
                                  padding: EdgeInsets.only(top: 10))),
                          Spacer(),
                          Text(
                            '$version ($buildNo)',
                            style: TextStyles.textDefault,
                          )
                        ]),
                        align: Alignment.bottomLeft),
                    SizedBox(height: 25),
                    _renderItemContainer(Tooltip(
                      key: toolTipKey,
                      decoration: BoxDecoration(
                          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(8.0),
                      showDuration: const Duration(seconds: 2),
                      waitDuration: const Duration(seconds: 1),
                      message:
                          "We respect your privacy, data share with KHIND is protected under the PDPA.",
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            final dynamic _toolTip = toolTipKey.currentState;
                            _toolTip.ensureTooltipVisible();
                          },
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Icon(Icons.info_outline_rounded),
                            SizedBox(width: 5),
                            Container(
                                child: _renderLabel("PDPA", textStyle: TextStyles.textDefault))
                          ])),
                    )),
                    SizedBox(height: 20),
                  ])),
          Expanded(child: Container()),
          RoundButton(
              title: 'Sign Out',
              height: MediaQuery.of(context).size.height * 0.08,
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(0),
              titleStyles: TextStyles.textDefaultW500.copyWith(fontSize: 18),
              onPressed: () async {
                Helpers.showAlert(context,
                    okTitle: "Yes",
                    noTitle: "No",
                    title: "Sign out confirmation",
                    desc: "Are you sure to sign out?",
                    hasAction: true,
                    hasCancel: true, onPressed: () async {
                  var response = await Api.bearerPost('logout');

                  // print("#LOGOUT RESPONSE: $response");
                  await storage.delete(key: IS_AUTH);

                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, 'landing', (route) => false);
                });
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: "My Profile", isBack: true, hasActions: false, handleBackPressed: () {
        if (widget.data == 1) {
          Navigator.pushReplacementNamed(context, 'home', arguments: 0);
        } else {
          Navigator.pop(context);
        }
      }),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderForm(),
        )
      ]),
    );
  }
}
