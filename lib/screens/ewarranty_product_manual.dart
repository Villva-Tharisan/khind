import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/cubit/product_group/product_group_cubit.dart';
import 'package:khind/cubit/product_model/product_model_cubit.dart';
import 'package:khind/cubit/store/store_cubit.dart';
import 'package:khind/models/product_model.dart';
import 'package:khind/models/user.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EwarrantyProductManual extends StatefulWidget {
  @override
  _EwarrantyProductManualState createState() => _EwarrantyProductManualState();
}

class _EwarrantyProductManualState extends State<EwarrantyProductManual> {
  final toolTipKey = GlobalKey<State<Tooltip>>();
  int quantity = 0;
  String fileName = '';

  String? chosenStore;

  String? chosenProductGroup;
  String? chosenProductModel;
  String? productModel;

  DateTime choosenDate = DateTime.now();

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // chosenProductGroup = productGroup[0];
    // chosenProductModel = productModel[0];
    ref.text = '';
    emailTEC.text = '';
    product.text = '';
    _loadUser();

    context.read<ProductGroupCubit>().getProductGroup();
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

  bool displayDate = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController ref = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController product = new TextEditingController();

  late File receiptFile;

  int? index;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: Helpers.customAppBar(
          context,
          _scaffoldKey,
          title: "Register New Product",
          hasActions: false,
          isBack: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Please provide us with your product information'),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.1),
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                    ],
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text('Product Group'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: BlocBuilder<ProductGroupCubit, ProductGroupState>(
                              builder: (context, state) {
                                if (state is ProductGroupLoaded) {
                                  return DropdownButton<String>(
                                    items: state.productModel
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: chosenProductGroup,
                                    onChanged: (value) {
                                      setState(() {
                                        chosenProductGroup = value!;
                                        chosenProductModel = null;
                                      });
                                      context
                                          .read<ProductModelCubit>()
                                          .getProductModel(productGroup: value!);
                                    },
                                  );
                                } else {
                                  return SpinKitFadingCircle(
                                    color: Colors.black,
                                    size: 20,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      BlocBuilder<ProductModelCubit, ProductModelState>(
                        builder: (context, state) {
                          if (state is ProductModelLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: width * 0.3,
                                      child: Text('Product Model'),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TypeAheadField(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: product,
                                          autofocus: true,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(fontStyle: FontStyle.italic),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          return await Repositories.getProductModelList(
                                              state.productName, pattern);
                                          // return await BackendService
                                          //     .getSuggestions(pattern);
                                        },
                                        itemBuilder: (context, suggestion) {
                                          // return Text(suggestion.toString());
                                          return ListTile(
                                            leading: Icon(Icons.shopping_cart),
                                            title: Text(suggestion.toString().toUpperCase()),
                                            // subtitle: Text(
                                            //   '\$${suggestion['price']}',
                                            // ),
                                          );
                                        },
                                        onSuggestionSelected: (suggestion) {
                                          product.text = suggestion.toString();
                                          print(suggestion.toString());
                                          setState(() {
                                            chosenProductModel = suggestion.toString();
                                            index = state.productName.indexOf(chosenProductModel!);

                                            productModel = state.productModel[index!];

                                            // print(productModel);
                                          });
                                        },
                                      ),
                                      // child: DropdownButton<String>(
                                      //   items: state.productName
                                      //       .map<DropdownMenuItem<String>>(
                                      //           (String value) {
                                      //     return DropdownMenuItem<String>(
                                      //       value: value,
                                      //       child: Text(
                                      //         value,
                                      //         overflow: TextOverflow.ellipsis,
                                      //         maxLines: 2,
                                      //       ),
                                      //     );
                                      //   }).toList(),
                                      //   isExpanded: true,
                                      //   value: chosenProductModel,
                                      //   onChanged: (value) {
                                      //     print(value);
                                      //     setState(() {
                                      //       chosenProductModel = value!;
                                      //       index = state.productName
                                      //           .indexOf(chosenProductModel!);

                                      //       productModel =
                                      //           state.productModel[index!];

                                      //       print(productModel);
                                      //     });
                                      //   },
                                      // ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Text('Product Description'),
                                SizedBox(height: 5),
                                index != null
                                    ? Text(
                                        state.modelDescription[index!],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      )
                                    : Container(),
                              ],
                            );
                          } else if (state is ProductModelInitial) {
                            return Container();
                          } else {
                            return SpinKitFadingCircle(
                              color: Colors.black,
                              size: 20,
                            );
                          }
                        },
                      ),

                      // SizedBox(height: 1),

                      //quantity
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
                    border: Border.all(width: 0.1),
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                    ],
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text('Purchase Date '),
                          ),
                          Text(
                            formatDate(choosenDate, ['dd', '-', 'mm', '-', 'yyyy']),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                              onPressed: () async {
                                DateTime? chosen = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                                  lastDate: DateTime.now(),
                                  initialEntryMode: DatePickerEntryMode.calendar,
                                );

                                if (chosen != null) {
                                  setState(() {
                                    choosenDate = chosen;
                                  });
                                }
                              },
                              icon: Icon(Icons.date_range, size: 20, color: Colors.black)),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     primary: Colors.blue,
                          //   ),
                          //   child: Text('Change Date'),
                          //   onPressed: () async {
                          //     DateTime? chosen = await showDatePicker(
                          //       context: context,
                          //       initialDate: DateTime.now(),
                          //       firstDate: DateTime.now().subtract(Duration(days: 30)),
                          //       lastDate: DateTime.now(),
                          //       initialEntryMode: DatePickerEntryMode.calendar,
                          //     );

                          //     if (chosen != null) {
                          //       setState(() {
                          //         choosenDate = chosen;
                          //       });
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text('Purchase from'),
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
                            child: Text('Referral Code'),
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
                              // triggerMode: TooltipTriggerMode.tap,
                              message:
                                  'Please insert any promo or referral codes obtain you obtain from KHIND promotional material or Authorized Khind Dealers',
                              child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    final dynamic _toolTip = toolTipKey.currentState;
                                    _toolTip.ensureTooltipVisible();
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.infoCircle,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                              // child: Icon(
                              //   FontAwesomeIcons.infoCircle,
                              //   color: Colors.green,
                              // ),
                              ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (Helpers.fromSignIn!)
                        Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('Email Address'),
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
                            style: ElevatedButton.styleFrom(primary: AppColors.secondary),
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
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
                SizedBox(height: 30),
                GradientButton(
                  height: 40,
                  child: Text(
                    "Register Product",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.grey[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  onPressed: () async {
                    String email = '';
                    if (emailTEC.text == '') {
                      email = user!.email!.toLowerCase();
                    } else {
                      email = emailTEC.text;
                    }

                    bool response = await Repositories.registerEwarranty(
                      email: email,
                      productModel: productModel!,
                      quantity: '$quantity',
                      purchaseDate: formatDate(choosenDate, ['yyyy', '-', 'mm', '-', 'dd']),
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

                    if (response) {
                      Alert(
                        context: context,
                        // type: AlertType.info,
                        title: "Register Product",
                        desc: "Your product is registered",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Okay",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                              'home',
                              (route) => false,
                              arguments: 0,
                            ),
                            width: 120,
                          )
                        ],
                      ).show();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Something went wrong, please try again',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
