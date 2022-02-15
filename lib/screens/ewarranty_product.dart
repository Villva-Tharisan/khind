import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/cubit/store/store_cubit.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/user.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:http/http.dart' as http;

class EwarrantyProduct extends StatefulWidget {
  final Map arguments;

  const EwarrantyProduct({Key? key, required this.arguments}) : super(key: key);
  @override
  _EwarrantyProductState createState() => _EwarrantyProductState();
}

class _EwarrantyProductState extends State<EwarrantyProduct> {
  final toolTipKey = GlobalKey<State<Tooltip>>();
  int quantity = 0;
  String fileName = '';
  late File receiptFile;
  DateTime choosenDate = DateTime.now();
  bool displayDate = false;

  String? chosenStore;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      choosenDate = args.value;
      displayDate = false;
    });

    print(choosenDate.toString());
  }

  TextEditingController ref = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    ref.text = '';
    emailTEC.text = '';
    _loadUser();
    context.read<StoreCubit>().getStore();

    super.initState();
  }

  User? user;

  _loadUser() async {
    var userStorage = await storage.read(key: USER);

    if (userStorage != null) {
      User userJson = User.fromJson(jsonDecode(userStorage));

      setState(() {
        user = userJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        40;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Scaffold(
        appBar: Helpers.customAppBar(
          context,
          _scaffoldKey,
          title: "Ewarranty",
          hasActions: false,
          isBack: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            height: height,
            child: FutureBuilder(
              future: Repositories.getProduct(
                  productModel: widget.arguments['productModel']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ProductWarranty productWarranty =
                      productWarrantyFromJson(snapshot.data.toString());

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Please provide us with your product information'),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0.5,
                              color: Colors.grey,
                              spreadRadius: 0.5,
                              // offset:
                            ),
                          ],
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productWarranty.data![0].productGroupDescription!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              productWarranty.data![0].modelDescription!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text('Quantity'),
                                SizedBox(width: 30),
                                // Text

                                GestureDetector(
                                  onTap: () {
                                    if (quantity != 0) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //   color: Colors.grey.shade300,
                                    //   border: Border.all(color: Colors.grey),
                                    // ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 20,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 7.5),
                                Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 7.5),
                                GestureDetector(
                                  onTap: () {
                                    if (quantity < 5) {
                                      setState(() {
                                        quantity++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //   color: Colors.grey.shade300,
                                    //   border: Border.all(color: Colors.grey),
                                    // ),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text('Warranty Period : '),
                                Text(
                                  '${formatDate(choosenDate, [
                                        'dd',
                                        '-',
                                        'mm',
                                        '-',
                                        'yyyy'
                                      ])} - ${formatDate(choosenDate.add(Duration(days: 365)), [
                                        'dd',
                                        '-',
                                        'mm',
                                        '-',
                                        'yyyy'
                                      ])}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0.5,
                              color: Colors.grey,
                              spreadRadius: 0.5,
                              // offset:
                            ),
                          ],
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width * 0.3,
                                  child: Text('Purchase Date '),
                                ),
                                Text(
                                  formatDate(choosenDate,
                                      ['dd', '-', 'mm', '-', 'yyyy']),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  child: Text('Change Date'),
                                  onPressed: () async {
                                    DateTime? chosen = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000, 1),
                                      lastDate: DateTime.now(),
                                      initialEntryMode:
                                          DatePickerEntryMode.calendar,
                                    );

                                    if (chosen != null) {
                                      setState(() {
                                        choosenDate = chosen;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  width: width * 0.3,
                                  child: Text('Purchase from '),
                                ),
                                BlocBuilder<StoreCubit, StoreState>(
                                  builder: (context, state) {
                                    if (state is StoreLoaded) {
                                      return Expanded(
                                        child: DropdownButton<String>(
                                          items: state.store.data!.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e.storeName!),
                                              value: e.storeId,
                                            );
                                          }).toList(),
                                          // items: state.store.data
                                          //     .map<DropdownMenuItem<String>>(
                                          //         (String value) {
                                          //   return DropdownMenuItem<String>(
                                          //     value: value,
                                          //     child: Text(
                                          //       value,
                                          //       overflow: TextOverflow.ellipsis,
                                          //       maxLines: 2,
                                          //     ),
                                          //   );
                                          // }).toList(),
                                          isExpanded: true,
                                          value: chosenStore,
                                          onChanged: (value) {
                                            print(value);
                                            setState(() {
                                              chosenStore = value!;
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      return SpinKitFadingCircle(
                                        color: Colors.black,
                                        size: 20,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: width * 0.3,
                                  child: Text('Referral Code '),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: ref,
                                    onChanged: (value) {},
                                  ),
                                ),
                                SizedBox(width: 5),
                                Tooltip(
                                    key: toolTipKey,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    message:
                                        'Please insert any promo or referral codes obtain you obtain from KHIND promotional material or Authorized Khind Dealers',
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          final dynamic _toolTip =
                                              toolTipKey.currentState;
                                          _toolTip.ensureTooltipVisible();
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.infoCircle,
                                          color: Colors.green,
                                        ))),
                                // Tooltip(
                                //   padding: EdgeInsets.all(10),
                                //   margin: EdgeInsets.all(10),
                                //   triggerMode: TooltipTriggerMode.tap,
                                //   message:
                                //       'Please insert any promo or referral codes obtain you obtain from KHIND promotional material or Authorized Khind Dealers',
                                //   child: Icon(
                                //     FontAwesomeIcons.infoCircle,
                                //     color: Colors.green,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 10),
                            if (Helpers.fromSignIn!)
                              Row(
                                children: [
                                  Container(
                                    width: width * 0.3,
                                    child: Text('Email address'),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: emailTEC,
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green),
                                  onPressed: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpg',
                                        'JPG',
                                        'jpeg',
                                        'JPEG',
                                        'png',
                                        'PNG',
                                        'heic',
                                        'HEIC',
                                        'pdf',
                                        'PDF',
                                      ],
                                    );

                                    if (result != null) {
                                      PlatformFile file = result.files.first;

                                      setState(() {
                                        fileName = file.name;
                                        receiptFile = File(file.path!);
                                      });

                                      print(file.name);
                                      print(file.bytes);
                                      print(file.size);
                                      print(file.extension);
                                      print(file.path);
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                  child: Text('Upload Receipt'),
                                ),
                                // GestureDetector(
                                //   onTap: () async {
                                //     FilePickerResult? result =
                                //         await FilePicker.platform.pickFiles(
                                //       type: FileType.custom,
                                //       allowedExtensions: [
                                //         'jpg',
                                //         'JPG',
                                //         'jpeg',
                                //         'JPEG',
                                //         'png',
                                //         'PNG',
                                //         'heic',
                                //         'HEIC',
                                //         'pdf',
                                //         'PDF',
                                //       ],
                                //     );

                                //     if (result != null) {
                                //       PlatformFile file = result.files.first;

                                //       setState(() {
                                //         fileName = file.name;
                                //         receiptFile = File(file.path!);
                                //       });

                                //       print(file.name);
                                //       print(file.bytes);
                                //       print(file.size);
                                //       print(file.extension);
                                //       print(file.path);
                                //     } else {
                                //       // User canceled the picker
                                //     }
                                //   },
                                //   child: Container(
                                //     padding: EdgeInsets.all(5),
                                //     decoration: BoxDecoration(
                                //       // color: Color(0xFFEFF0EF),
                                //       color: Colors.grey.withOpacity(0.5),
                                //       borderRadius: BorderRadius.circular(7.5),
                                //     ),
                                //     child: Text('Upload Receipt'),
                                //   ),
                                // ),
                                SizedBox(width: 20),
                                Expanded(child: Text(fileName)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 15),
                      // Container(
                      //   width: double.infinity,
                      //   padding: EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         blurRadius: 0.5,
                      //         color: Colors.grey,
                      //         spreadRadius: 0.5,
                      //         // offset:
                      //       ),
                      //     ],
                      //     borderRadius: BorderRadius.circular(7.5),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () async {
                      //           FilePickerResult? result =
                      //               await FilePicker.platform.pickFiles(
                      //             type: FileType.image,
                      //           );

                      //           if (result != null) {
                      //             PlatformFile file = result.files.first;

                      //             setState(() {
                      //               fileName = file.name;
                      //               receiptFile = File(file.path!);
                      //             });

                      //             print(file.name);
                      //             print(file.bytes);
                      //             print(file.size);
                      //             print(file.extension);
                      //             print(file.path);
                      //           } else {
                      //             // User canceled the picker
                      //           }
                      //         },
                      //         child: Container(
                      //           padding: EdgeInsets.all(5),
                      //           decoration: BoxDecoration(
                      //             // color: Color(0xFFEFF0EF),
                      //             color: Colors.grey.withOpacity(0.5),
                      //             borderRadius: BorderRadius.circular(7.5),
                      //           ),
                      //           child: Text('Upload Receipt'),
                      //         ),
                      //       ),
                      //       SizedBox(width: 20),
                      //       Expanded(child: Text(fileName)),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 15),

                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GradientButton(
                            height: 40,
                            child: Text(
                              "Register Product",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            gradient: LinearGradient(
                              colors: <Color>[Colors.white, Colors.grey[400]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            onPressed: () async {
                              String email = '';
                              if (emailTEC.text == '') {
                                email = user!.email!.toLowerCase();
                              } else {
                                email = emailTEC.text;
                              }
                              await Repositories.registerEwarranty(
                                email: email,
                                productModel:
                                    productWarranty.data![0].productModel!,
                                quantity: '$quantity',
                                purchaseDate: formatDate(choosenDate,
                                    ['yyyy', '-', 'mm', '-', 'dd']),
                                referralCode: ref.text,
                                receiptFile: receiptFile,
                              );

                              // print(ref.text);
                              // FormData formData = new FormData.from({
                              //   "name": "wendux",
                              //   "file1": new UploadFileInfo(
                              //       new File("./upload.jpg"), "upload1.jpg")
                              // });
                              // response = await dio.post("/info", data: formData);

                              Alert(
                                context: context,
                                // type: AlertType.info,
                                title: "Register Product",
                                desc: "Your product is registered",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Okay",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      'home',
                                      (route) => false,
                                      arguments: 0,
                                    ),
                                    width: 120,
                                  )
                                ],
                              ).show();
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.black,
                      size: 30,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
