import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khind/models/city.dart';
import 'package:khind/models/states.dart';
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
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final toolTipKey = GlobalKey<State<Tooltip>>();
  final storage = new FlutterSecureStorage();
  TextEditingController mobileNoCT = new TextEditingController();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController dobCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController postCodeCT = new TextEditingController();
  TextEditingController address1CT = new TextEditingController();
  TextEditingController address2CT = new TextEditingController();
  bool isLoading = false;
  User? user;
  String errorMsg = "";
  List errors = [];
  DateTime now = DateTime.now();
  DateTime selectedDob = DateTime(DateTime.now().year - 10);
  final textStyle = TextStyle(fontSize: 14);
  bool canEditMobile = false;
  bool canEditEmail = false;
  bool canEditDob = false;
  bool canEditAddress = false;
  List<City> _cities = [];
  List<States> _states = [];
  late States state;
  late City city;
  String version = "";
  String buildNo = "";
  String postcode = "";

  @override
  void initState() {
    // firstNameCT.text = "test";
    // lastNameCT.text = "khind";
    // mobileNoCT.text = "0156663229";
    // emailCT.text = "test.khind@gmail.com";
    // passwordCT.text = "p455word";
    // dobCT.text = "01-01-1990";
    // confirmPasswordCT.text = "p455word";
    // setState(() {
    //   user = User.fromJson({
    //     'id': "1",
    //     'name': 'Khind',
    //     'mobile': '0167332333',
    //     'email': 'khindcustomerservice@gmail.com',
    //     'address': 'Nu Sentral'
    //   });
    // });
    _loadUser();
    _loadVersion();
    super.initState();
  }

  _loadUser() async {
    var userStorage = await storage.read(key: USER);

    if (userStorage != null) {
      User userJson = User.fromJson(jsonDecode(userStorage));

      setState(() {
        user = userJson;

        if (userJson.telephone != null) {
          mobileNoCT.text = userJson.telephone!;
        }

        if (userJson.telephone != null) {
          emailCT.text = userJson.email!;
        }

        if (userJson.dob != null) {
          dobCT.text = userJson.dob!;
        }
      });
      // print("###USER: ${jsonEncode(user)}");
    }
  }

  Future<void> fetchStates() async {
    final response = await Api.bearerGet('provider/state.php', isCms: true);

    var states = (response['states'] as List).map((i) => States.fromJson(i)).toList();

    states.insert(0, new States(countryId: "", state: "--Select--", stateId: "", stateCode: ""));

    setState(() {
      _states = states;
      state = states[0];
    });
  }

  Future<void> fetchCities(String stateId) async {
    final response = await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var cities = (response['city'] as List).map((i) => City.fromJson(i)).toList();

    cities.insert(
        0, new City(stateId: "", city: "--Select--", cityId: "", postcodeId: "", postcode: ""));
    // print("#CITIES: $cities");
    var citySet = Set<String>();
    List<City> newCities = cities.where((e) => citySet.add(e.city!)).toList();

    setState(() {
      _cities = newCities;
      city = newCities[0];
    });
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
    super.dispose();
  }

  void _clearTextField() {
    emailCT.clear();
    mobileNoCT.clear();
    passwordCT.clear();
    address1CT.clear();
    address2CT.clear();
  }

  void showEditField(name) {
    setState(() {
      if (name == 'mobile') {
        canEditMobile = true;
      } else if (name == 'email') {
        canEditEmail = true;
      } else if (name == 'dob') {
        canEditDob = true;
      } else if (name == 'address') {
        canEditAddress = true;
      }
    });
  }

  void _handleUpdate() async {
    Helpers.showAlert(context);
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> map = {
        'email': emailCT.text,
        'password': passwordCT.text,
        'telephone': mobileNoCT.text,
        'address1': address1CT.text,
        'address2': address1CT.text,
        'state': state,
        'city': city,
        'postcode': postcode,
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
        dobCT.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Widget _renderDivider() {
    return Container(height: 1, color: Colors.grey[300], width: double.infinity);
  }

  Widget _renderItemContainer(child, {align}) {
    return Container(
        alignment: align != null ? align : Alignment.center,
        padding: const EdgeInsets.only(right: 10, top: 0, bottom: 0),
        child: child);
  }

  Widget _renderEditBtn(name, {icon}) {
    Color color = AppColors.secondary;

    return InkWell(
        onTap: () {
          setState(() {
            if (name == 'dob') {
              canEditDob = !this.canEditDob;
              color = Colors.grey;
            } else if (name == 'mobile') {
              canEditMobile = !this.canEditMobile;
              color = Colors.grey;
            } else if (name == 'email') {
              canEditEmail = !this.canEditEmail;
              color = Colors.grey;
            } else if (name == 'address') {
              canEditAddress = !this.canEditAddress;
              color = Colors.grey;
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: icon != null ? icon : Text("Edit", style: TextStyles.textWhiteSm)));
  }

  Widget _renderIcon(IconData icon, {onPressed}) {
    return IconButton(onPressed: onPressed, icon: Icon(icon, size: 20, color: Colors.black));
  }

  Widget _renderLabel(title, {padding, textStyle}) {
    return Container(
        padding: padding != null ? padding : EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(title, style: textStyle != null ? textStyle : TextStyles.textDefault));
  }

  Widget _renderField({val}) {
    if (val == null || val == "") {
      return Container(padding: const EdgeInsets.only(top: 25, bottom: 20));
    }
    return Flexible(
        child: Container(padding: const EdgeInsets.only(top: 25, bottom: 20), child: Text('$val')));
  }

  Widget renderAddress() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15),
                width: width * 0.30,
                child: Text('Address Line 1'),
              ),
              SizedBox(width: 15),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter address 1';
                    }
                    return null;
                  },
                  controller: address1CT,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg: No 78 Jalan Mawar',
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15),
                width: width * 0.30,
                child: Text('Address Line 2'),
              ),
              SizedBox(width: 15),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return null;
                  },
                  controller: address2CT,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg: Puchong Perdana',
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15),
                width: width * 0.30,
                child: Text('State'),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: width * 0.45,
                  child: DropdownButton<States>(
                    items: _states.map<DropdownMenuItem<States>>((e) {
                      return DropdownMenuItem<States>(
                        child: Text(
                          e.state!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        value: e,
                      );
                    }).toList(),
                    isExpanded: true,
                    value: state,
                    onChanged: (value) {
                      setState(() {
                        state = value!;
                        this.fetchCities(value.stateId!);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          _cities.length > 0
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      width: width * 0.30,
                      child: Text('City'),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width * 0.45,
                        child: DropdownButton<City>(
                          items: _cities.map<DropdownMenuItem<City>>((e) {
                            return DropdownMenuItem<City>(
                              child: Text(
                                e.city!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              value: e,
                            );
                          }).toList(),
                          isExpanded: true,
                          value: city,
                          onChanged: (value) {
                            setState(() {
                              city = value!;
                              // this.onSelectCity(value.postcode!);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.only(top: 15),
          //       width: width * 0.30,
          //       child: Text('Postcode'),
          //     ),
          //     SizedBox(width: 15),
          //     Flexible(
          //       child: TextFormField(
          //         keyboardType: TextInputType.text,
          //         validator: (value) {
          //           if (value!.isEmpty) {
          //             return 'Please enter postcode';
          //           }
          //           return null;
          //         },
          //         controller: postCodeCT,
          //         onFieldSubmitted: (val) {
          //           FocusScope.of(context).requestFocus(new FocusNode());
          //         },
          //         decoration: InputDecoration(
          //           border: InputBorder.none,
          //           hintText: 'eg: 40050',
          //           contentPadding:
          //               const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _renderForm() {
    // print("#USER: ${user}");

    double fieldSize = MediaQuery.of(context).size.width * 0.5;

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
                      _renderField(val: '${user?.firstname} ${user?.lastname}')
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
                            onTap: () {
                              setState(() {
                                canEditMobile = !this.canEditMobile;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(canEditMobile ? "View" : "Edit",
                                    style: TextStyles.textWhiteSm)))
                      ]))
                    ])),
                    SizedBox(height: 5),
                    _renderDivider(),
                    SizedBox(height: 10),
                    _renderItemContainer(Row(children: [
                      _renderLabel("Email", textStyle: TextStyles.textDefault),
                      Flexible(
                          child: Row(children: [
                        Container(
                            width: fieldSize,
                            child: TextFormField(
                              controller: emailCT,
                              enabled: canEditEmail,
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
                            )),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              setState(() {
                                canEditEmail = !this.canEditEmail;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(canEditEmail ? "View" : "Edit",
                                    style: TextStyles.textWhiteSm)))
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
                          controller: dobCT,
                          enabled: canEditDob,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            RegExp regExp = new RegExp(
                                r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');
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
                                  onTap: () {
                                    setState(() {
                                      canEditDob = !this.canEditDob;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Text(canEditDob ? "View" : "Edit",
                                          style: TextStyles.textWhiteSm)))
                            ]))
                      ]))
                    ])),
                    SizedBox(height: 5),
                    _renderDivider(),
                    SizedBox(height: 20),
                    _renderItemContainer(
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _renderLabel("Address",
                          textStyle: TextStyles.textDefault, padding: EdgeInsets.only(top: 10)),
                      renderAddress()
                      // Flexible(
                      //     child: Row(
                      //         // crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //       Container(
                      //           width: fieldSize,
                      //           child: TextFormField(
                      //               keyboardType: TextInputType.text,
                      //               minLines: 3,
                      //               maxLines: null,
                      //               validator: (value) {
                      //                 if (value!.isEmpty) {
                      //                   return 'Please enter address';
                      //                 }
                      //                 return null;
                      //               },
                      //               controller: addressCT,
                      //               onFieldSubmitted: (val) {},
                      //               decoration: InputDecoration(
                      //                 border: InputBorder.none,
                      //                 hintText: '',
                      //               ))),
                      //       Spacer(),
                      //       InkWell(
                      //           onTap: () {
                      //             setState(() {
                      //               canEditAddress = !this.canEditAddress;
                      //             });
                      //           },
                      //           child: Container(
                      //               decoration: BoxDecoration(
                      //                   color: AppColors.secondary,
                      //                   borderRadius: BorderRadius.circular(10)),
                      //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //               child: Text(canEditAddress ? "View" : "Edit",
                      //                   style: TextStyles.textWhiteSm)))
                      //     ]))
                    ])),
                    SizedBox(height: 5),
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
                    SizedBox(height: 20),
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
