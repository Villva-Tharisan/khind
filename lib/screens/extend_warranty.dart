import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/cubit/product_model/product_model_cubit.dart';
import 'package:khind/cubit/store/store_cubit.dart';
import 'package:khind/models/Purchase.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ExtendWarranty extends StatefulWidget {
  const ExtendWarranty({Key? key}) : super(key: key);

  @override
  State<ExtendWarranty> createState() => _ExtendWarrantyState();
}

class _ExtendWarrantyState extends State<ExtendWarranty> {
  late Purchase purchase;

  late DateTime purchaseDate;
  late DateTime endDate;

  ProductWarranty? productWarranty;

  TextEditingController serialNo = TextEditingController();

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    context.read<StoreCubit>().getStore();
    purchase = Helpers.purchase!;
    productWarranty = Helpers.productWarranty;
    purchaseDate = DateTime.parse(purchase.purchaseDate!);
    endDate = purchaseDate.add(Duration(days: int.parse(purchase.numPeriods!) * 365));
    serialNo.text = '';
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime now = DateTime.now();

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // print("##COST: ${productWarranty!.data![0].extendedWarrantyCharge1Yr}");
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Extend Warranty'),
      // ),

      appBar: Helpers.customAppBar(
        context,
        _scaffoldKey,
        title: "Extend Warranty",
        hasActions: false,
        isBack: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.4,
                  color: Colors.grey.withOpacity(0.5),
                ),
                boxShadow: [
                  BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                ],
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.productGroupDescription!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(purchase.modelDescription!, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Text('Serial Number:'),
                  //     SizedBox(width: 10),
                  //     Text(purchase.serialNo != null ? purchase.serialNo.toString() : "-"),
                  //     // Expanded(
                  //     //   child: DropdownButton<String>(
                  //     //     items: productModel
                  //     //         .map<DropdownMenuItem<String>>((String value) {
                  //     //       return DropdownMenuItem<String>(
                  //     //         value: value,
                  //     //         child: Text(
                  //     //           value,
                  //     //           overflow: TextOverflow.ellipsis,
                  //     //           maxLines: 2,
                  //     //         ),
                  //     //       );
                  //     //     }).toList(),
                  //     //     isExpanded: true,
                  //     //     value: chosenProductModel,
                  //     //     onChanged: (value) {
                  //     //       setState(() {
                  //     //         chosenProductModel = value.toString();
                  //     //       });
                  //     //     },
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Warranty valid until:'),
                      SizedBox(width: 5),
                      Expanded(
                          child:
                              Text('${purchase.warrantyDate}', style: TextStyles.textDefaultBold)),
                      // Expanded(
                      //   child: Text(
                      //       '${formatDate(purchaseDate, [
                      //             'dd',
                      //             '-',
                      //             'mm',
                      //             '-',
                      //             'yyyy'
                      //           ])} - ${formatDate(endDate, [
                      //             'dd',
                      //             '-',
                      //             'mm',
                      //             '-',
                      //             'yyyy'
                      //           ])}',
                      //       style: TextStyle(fontWeight: FontWeight.bold)),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            //purchase date
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.4,
                  color: Colors.grey.withOpacity(0.5),
                ),
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
                      Text('Purchase Date : '),
                      Text(formatDate(purchaseDate, ['dd', '-', 'mm', '-', 'yyyy']),
                          style: TextStyles.textDefaultBold),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('New Extended Warranty'),
                  SizedBox(height: 5),
                  Text(
                    '${formatDate(endDate, [
                          'dd',
                          '-',
                          'mm',
                          '-',
                          'yyyy'
                        ])} - ${formatDate(endDate.add(Duration(days: 365)), [
                          'dd',
                          '-',
                          'mm',
                          '-',
                          'yyyy'
                        ])}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            productWarranty!.data![0].extendedWarrantyCharge1Yr != "0"
                ? SizedBox(height: 20)
                : Container(),
            productWarranty!.data![0].extendedWarrantyCharge1Yr != "0"
                ? Row(
                    children: [
                      Container(
                        // width: width * 0.3,
                        child: Text('Serial Number : '),
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: serialNo,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == '' || value == null) {
                                return 'Please key in Serial No.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),

            SizedBox(height: 20),

            Row(
              children: [
                Container(
                  // width: width * 0.3,
                  child: Text('Purchase from : '),
                ),
                BlocBuilder<StoreCubit, StoreState>(
                  builder: (context, state) {
                    if (state is StoreLoaded) {
                      String storeName = '-';
                      // print("STORE: ${state.store.data}");

                      for (var i = 0; i < state.store.data!.length; i++) {
                        if (purchase.storeId == state.store.data![i].storeId) {
                          storeName = state.store.data![i].storeName!;
                        }
                      }

                      return Text(storeName);
                      // return Expanded(
                      //   child: DropdownButton<String>(
                      //     items: state.store.data!.map((e) {
                      //       return DropdownMenuItem(
                      //         child: Text(e.storeName!),
                      //         value: e.storeId,
                      //       );
                      //     }).toList(),
                      //     // items: state.store.data
                      //     //     .map<DropdownMenuItem<String>>(
                      //     //         (String value) {
                      //     //   return DropdownMenuItem<String>(
                      //     //     value: value,
                      //     //     child: Text(
                      //     //       value,
                      //     //       overflow: TextOverflow.ellipsis,
                      //     //       maxLines: 2,
                      //     //     ),
                      //     //   );
                      //     // }).toList(),
                      //     isExpanded: true,
                      //     value: chosenStore,
                      //     onChanged: (value) {
                      //       print(value);
                      //       setState(() {
                      //         chosenStore = value!;
                      //       });
                      //     },
                      //   ),
                      // );
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

            SizedBox(height: 10),
            Row(children: [
              Text('Warranty Cost : '),
              SizedBox(width: 2),
              productWarranty!.data![0].extendedWarrantyCharge1Yr != null &&
                      productWarranty!.data![0].extendedWarrantyCharge1Yr != "null"
                  ? Text('RM ${productWarranty!.data![0].extendedWarrantyCharge1Yr}',
                      style: TextStyle(fontWeight: FontWeight.bold))
                  : Text("-")
            ]),

            // SizedBox(height: 50),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: productWarranty!.data![0].extendedWarrantyCharge1Yr != "0"
                    ? GradientButton(
                        height: 40,
                        child: Text(
                          "Apply",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        gradient: LinearGradient(
                            colors: <Color>[Colors.white, Colors.grey[400]!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            bool successExtend = await Repositories.sendExtend(
                              warrantyId: purchase.warrantyRegistrationId,
                            );

                            bool successSerial = await Repositories.sendSerialNumber(
                              serialNo: serialNo.text,
                              warrantyId: purchase.warrantyRegistrationId,
                            );

                            if (successExtend && successSerial) {
                              Alert(
                                context: context,
                                // type: AlertType.info,
                                title: "Warranty Extension Submitted",
                                desc:
                                    "You will be notified in 2 days on the approval of the extension. Please ensure that payment is done within 7 days after approval",
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
                          }
                        },
                      )
                    : GradientButton(
                        hideShadow: true,
                        height: 40,
                        child: Text(
                          "Apply",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        gradient: LinearGradient(
                            colors: <Color>[Colors.grey[300]!, Colors.grey[300]!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        onPressed: () {},
                      ),
              ),
            ),

            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SizedBox(
            //       width: double.infinity,
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(primary: Colors.grey),
            //         onPressed: () {},
            //         child: Text('Apply'),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
