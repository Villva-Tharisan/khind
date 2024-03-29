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
import 'package:jiffy/jiffy.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/cubit/product_group/product_group_cubit.dart';
import 'package:khind/cubit/product_model/product_model_cubit.dart';
import 'package:khind/cubit/store/store_cubit.dart';
import 'package:khind/models/product_model.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/user.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';
import 'package:khind/util/key.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EwarrantyProductManual extends StatefulWidget {
  bool isFromWarranty;

  EwarrantyProductManual({required this.isFromWarranty});
  @override
  _EwarrantyProductManualState createState() => _EwarrantyProductManualState();
}

class _EwarrantyProductManualState extends State<EwarrantyProductManual> {
  final toolTipKey = GlobalKey<State<Tooltip>>();
  int quantity = 1;
  String fileName = '';

  String? chosenStore;

  String? chosenProductGroup;
  String? chosenProductModel;
  String? productModel;

  DateTime choosenDate = DateTime.now();
  DateTime? endWarranty;

  int? monthsWarranty;

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
  TextEditingController productGroup = new TextEditingController();
  TextEditingController product = new TextEditingController();

  late File receiptFile;

  int? index;

  final _formKey = GlobalKey<FormState>();

  bool checkForm = false;

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
        appBar: Helpers.customAppBar(context, _scaffoldKey,
            title: "Register New Product",
            hasActions: false,
            isBack: widget.isFromWarranty ? true : false,
            isPrimary: true),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey[200]!,
                            offset: Offset(0, 10)),
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
                              child: BlocBuilder<ProductGroupCubit,
                                  ProductGroupState>(
                                builder: (context, state) {
                                  if (state is ProductGroupLoaded) {
                                    return TypeAheadField(
                                      hideSuggestionsOnKeyboardHide: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: productGroup,
                                        autofocus: false,
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                                fontStyle: FontStyle.italic),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return await Repositories
                                            .getProductModelList(
                                                state.productModel, pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        // return Text(suggestion.toString());
                                        return ListTile(
                                          leading: Icon(Icons.shopping_cart),
                                          title: Text(suggestion
                                              .toString()
                                              .toUpperCase()),
                                          // subtitle: Text(
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) async {
                                        productGroup.text =
                                            suggestion.toString();
                                        setState(() {
                                          chosenProductGroup =
                                              suggestion.toString();
                                          chosenProductModel = null;
                                        });
                                        context
                                            .read<ProductModelCubit>()
                                            .getProductModel(
                                                productGroup:
                                                    suggestion.toString());
                                        product.text = '';
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
                            // Expanded(
                            //   child: BlocBuilder<ProductGroupCubit,
                            //       ProductGroupState>(
                            //     builder: (context, state) {
                            //       if (state is ProductGroupLoaded) {
                            //         return DropdownButtonFormField<String>(
                            //           validator: (value) {
                            //             if (value == null || value == '') {
                            //               return "Please select product group";
                            //             }

                            //             return null;
                            //           },
                            //           items: state.productModel
                            //               .map<DropdownMenuItem<String>>(
                            //                   (String value) {
                            //             return DropdownMenuItem<String>(
                            //               value: value,
                            //               child: Text(
                            //                 value,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 maxLines: 2,
                            //               ),
                            //             );
                            //           }).toList(),
                            //           isExpanded: true,
                            //           value: chosenProductGroup,
                            //           onChanged: (value) {
                            //             setState(() {
                            //               chosenProductGroup = value!;
                            //               chosenProductModel = null;
                            //             });
                            //             context
                            //                 .read<ProductModelCubit>()
                            //                 .getProductModel(
                            //                     productGroup: value!);
                            //             product.text = '';
                            //           },
                            //         );
                            //       } else {
                            //         return SpinKitFadingCircle(
                            //           color: Colors.black,
                            //           size: 20,
                            //         );
                            //       }
                            //     },
                            //   ),
                            // ),
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
                                          hideSuggestionsOnKeyboardHide: false,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: product,
                                            autofocus: true,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.italic),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            print(
                                                "#PRODUCTNAME: ${state.productName}");
                                            return await Repositories
                                                .getProductModelList(
                                                    state.productName, pattern);
                                            // return await BackendService
                                            //     .getSuggestions(pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            // return Text(suggestion.toString());
                                            return ListTile(
                                              leading:
                                                  Icon(Icons.shopping_cart),
                                              title: Text(suggestion
                                                  .toString()
                                                  .toUpperCase()),
                                              // subtitle: Text(
                                              //   '\$${suggestion['price']}',
                                              // ),
                                            );
                                          },
                                          onSuggestionSelected:
                                              (suggestion) async {
                                            product.text =
                                                suggestion.toString();
                                            print(suggestion.toString());

                                            setState(() {
                                              chosenProductModel =
                                                  suggestion.toString();
                                              index = state.productName
                                                  .indexOf(chosenProductModel!);

                                              productModel =
                                                  state.productModel[index!];

                                              // print(productModel);
                                            });

                                            Helpers.productWarranty =
                                                productWarrantyFromJson(
                                                    await Repositories
                                                        .getProduct(
                                                            productModel:
                                                                productModel!));

                                            setState(() {
                                              monthsWarranty = int.parse(Helpers
                                                  .productWarranty!
                                                  .data![0]
                                                  .warrantyMonths!);
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                if (quantity > 1) {
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
                                    child: DropdownButtonFormField<String>(
                                      validator: (value) {
                                        if (value == null || value == '') {
                                          return 'Please select purchase from';
                                        } else {
                                          return null;
                                        }
                                      },

                                      items: state.store.data!.map((e) {
                                        return DropdownMenuItem(
                                          child: Text(e.storeName!),
                                          value: e.storeName,
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
                        BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey[200]!,
                            offset: Offset(0, 10)),
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
                              formatDate(
                                  choosenDate, ['dd', '-', 'mm', '-', 'yyyy']),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            IconButton(
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
                                    endWarranty = Jiffy(choosenDate)
                                        .add(months: monthsWarranty!)
                                        .dateTime
                                        .subtract(Duration(days: 1));
                                  });
                                }
                              },
                              icon: Icon(Icons.date_range,
                                  size: 20, color: Colors.black),
                            ),

                            if (checkForm && endWarranty == null) ...[
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Please select purchase date',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ]

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
                            Text('Warranty Period : '),
                            if (monthsWarranty != null && endWarranty != null)
                              Text(
                                '${formatDate(choosenDate, [
                                      'dd',
                                      '-',
                                      'mm',
                                      '-',
                                      'yyyy'
                                    ])} to ${formatDate(endWarranty!, [
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
                        SizedBox(height: 10),
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
                                      final dynamic _toolTip =
                                          toolTipKey.currentState;
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
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == '' || value == null) {
                                      return 'Please fill in the email address';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  primary: endWarranty != null &&
                                          endWarranty!.isAfter(DateTime.now())
                                      ? AppColors.primary
                                      : AppColors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                print(endWarranty.toString());
                                if (endWarranty != null &&
                                    endWarranty!.isAfter(DateTime.now())) {
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
                                }
                              },
                              child: Text(
                                'Upload Receipt',
                                style: TextStyles.textDefaultBoldMd,
                              ),
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
                            if (checkForm &&
                                fileName == '' &&
                                endWarranty != null &&
                                endWarranty!.isAfter(DateTime.now()))
                              Expanded(
                                child: Text(
                                  'Please upload the receipt',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            Expanded(child: Text(fileName)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  RoundButton(
                      // color: AppColors.tertiery,
                      // height: 40,
                      // titleStyles: TextStyles.textDefault,
                      title: 'Register Product',
                      onPressed: () async {
                        setState(() {
                          checkForm = true;
                        });
                        if (_formKey.currentState!.validate()) {
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
                              purchaseDate: formatDate(
                                  choosenDate, ['yyyy', '-', 'mm', '-', 'dd']),
                              referralCode: ref.text,
                              receiptFile: receiptFile,
                              store: chosenStore != null ? chosenStore! : "");

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
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                    'home',
                                    (route) => false,
                                    arguments: 2,
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
                        }
                      }),
                  // GradientButton(
                  //   height: 40,
                  //   child: Text(
                  //     "Register Product",
                  //     style: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  //   gradient: LinearGradient(
                  //       colors: <Color>[Colors.white, Colors.grey[400]!],
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter),
                  //   onPressed: () async {
                  //     if (_formKey.currentState!.validate()) {
                  //       String email = '';
                  //       if (emailTEC.text == '') {
                  //         email = user!.email!.toLowerCase();
                  //       } else {
                  //         email = emailTEC.text;
                  //       }

                  //       bool response = await Repositories.registerEwarranty(
                  //           email: email,
                  //           productModel: productModel!,
                  //           quantity: '$quantity',
                  //           purchaseDate: formatDate(choosenDate, ['yyyy', '-', 'mm', '-', 'dd']),
                  //           referralCode: ref.text,
                  //           receiptFile: receiptFile,
                  //           store: chosenStore != null ? chosenStore! : "");

                  //       // print(ref.text);
                  //       // FormData formData = new FormData.from({
                  //       //   "name": "wendux",
                  //       //   "file1": new UploadFileInfo(
                  //       //       new File("./upload.jpg"), "upload1.jpg")
                  //       // });
                  //       // response = await dio.post("/info", data: formData);

                  //       if (response) {
                  //         Alert(
                  //           context: context,
                  //           // type: AlertType.info,
                  //           title: "Register Product",
                  //           desc: "Your product is registered",
                  //           buttons: [
                  //             DialogButton(
                  //               child: Text(
                  //                 "Okay",
                  //                 style: TextStyle(color: Colors.white, fontSize: 20),
                  //               ),
                  //               onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  //                 'home',
                  //                 (route) => false,
                  //                 arguments: 2,
                  //               ),
                  //               width: 120,
                  //             )
                  //           ],
                  //         ).show();
                  //       } else {
                  //         Fluttertoast.showToast(
                  //           msg: 'Something went wrong, please try again',
                  //           toastLength: Toast.LENGTH_LONG,
                  //           gravity: ToastGravity.BOTTOM,
                  //         );
                  //       }
                  //     }
                  // },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
