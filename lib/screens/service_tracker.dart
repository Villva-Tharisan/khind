import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/cubit/tracker/tracker_cubit.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/service_product.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';

class ServiceTracker extends StatefulWidget {
  const ServiceTracker({Key? key}) : super(key: key);

  @override
  State<ServiceTracker> createState() => _ServiceTrackerState();
}

class _ServiceTrackerState extends State<ServiceTracker> {
  @override
  void initState() {
    context.read<TrackerCubit>().getTracker('All');
    super.initState();
  }

  getColor(status) {
    var newColor = Colors.grey[400]!;

    if (status == 'Pending Collection') {
      newColor = Colors.red;
    } else if (status == 'Collected') {
      newColor = Colors.green;
    }
    return newColor;
  }

  String selectedStatus = "All";

  List<String> _status = ['All', 'Pending Collection', 'Not Started', 'Repairing', 'Collected'];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
          Helpers.customAppBar(context, _scaffoldKey, title: "Service Tracker", isPrimary: true),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: width * 0.5,
              margin: EdgeInsets.only(
                top: 15,
                right: 15,
                bottom: 10,
              ),
              child: DropdownButton<String>(
                items: _status.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    value: e,
                  );
                }).toList(),
                isExpanded: true,
                value: selectedStatus,
                onChanged: (value) {
                  // this.onSelectStatus(value!);
                  setState(() {
                    selectedStatus = value!;
                  });
                  context.read<TrackerCubit>().getTracker(value!);
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TrackerCubit, TrackerState>(
              builder: (context, state) {
                if (state is TrackerLoaded) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: state.serviceProduct.data!.length == 0
                        ? Center(
                            child: Text('There is nothing to track', style: TextStyles.textDefault),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.serviceProduct.data!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Helpers.productIndex = index;
                                            Helpers.serviceProduct = state.serviceProduct;

                                            Helpers.productWarranty = productWarrantyFromJson(
                                                await Repositories.getProduct(
                                                    productModel: state.serviceProduct.data![index]
                                                        ['product_model']!));

                                            if (Helpers.productWarranty!.data!.length != 0) {
                                              Navigator.of(context).pushNamed(
                                                  'ServiceTrackerDetails',
                                                  arguments: state.serviceProduct);
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: 'Something went wrong, please try again',
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: height * 0.15,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.1),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 5,
                                                    color: Colors.grey[200]!,
                                                    offset: Offset(0, 10)),
                                              ],
                                              borderRadius: BorderRadius.circular(7.5),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 15,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      // vertical: 10,
                                                    ),
                                                    child: Row(children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  state.serviceProduct.data![index]
                                                                      ['model_description']!,
                                                                  style: TextStyles.textDefaultBold,
                                                                ),
                                                              ),
                                                              SizedBox(height: 5),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  state.serviceProduct.data![index]
                                                                              ['product_model'] !=
                                                                          null
                                                                      ? state.serviceProduct
                                                                              .data![index]
                                                                          ['product_model']!
                                                                      : "",
                                                                  style: TextStyles.textDefaultBold,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Row(children: [
                                                                  Text("Ticket No. : "),
                                                                  Text(
                                                                    state.serviceProduct
                                                                        .data![index]['ticket_no']!,
                                                                    style: TextStyles.textDefault,
                                                                  )
                                                                ]),
                                                              )
                                                            ],
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                              height: 25,
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.end,
                                                                  children: [
                                                                    CustomCard(
                                                                        color: getColor(state
                                                                                .serviceProduct
                                                                                .data![index][
                                                                            'service_request_status']!),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                2),
                                                                        padding: const EdgeInsets
                                                                                .symmetric(
                                                                            vertical: 2,
                                                                            horizontal: 5),
                                                                        textStyle:
                                                                            TextStyles.textWhiteXs,
                                                                        label:
                                                                            '${state.serviceProduct.data![index]['service_request_status']!}'),
                                                                  ]))),
                                                    ]),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: state.serviceProduct.data![index]
                                                                  ['service_request_status'] ==
                                                              'Pending Collection'
                                                          ? Colors.green
                                                          : Colors.grey,
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 0.5,
                                                          color: Colors.grey,
                                                          spreadRadius: 0.5,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(Icons.chevron_right,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
        ],
      ),
      // body: FutureBuilder(
      //   future: Repositories.getServiceProduct(),
      //   builder: (context, snapshot) {
      //     // print("DATA: ${snapshot.data.runtimeType}");
      //     if (snapshot.hasData && snapshot.data != "[]") {
      //       ServiceProduct serviceProduct;
      //       serviceProduct =
      //           ServiceProduct.fromJson(json.decode(snapshot.data!.toString()));

      //       return Container(
      //         margin: EdgeInsets.symmetric(
      //           horizontal: 15,
      //           vertical: 20,
      //         ),
      //         child: serviceProduct.data!.length == 0
      //             ? Center(
      //                 child: Text('There is nothing to track',
      //                     style: TextStyles.textSecondaryBold),
      //               )
      //             : Column(
      //                 children: [
      //                   // Align(
      //                   //   alignment: Alignment.centerRight,
      //                   //   child: Container(
      //                   //     padding: EdgeInsets.symmetric(
      //                   //       horizontal: 20,
      //                   //       vertical: 5,
      //                   //     ),
      //                   //     decoration: BoxDecoration(
      //                   //       color: Colors.white,
      //                   //       boxShadow: [
      //                   //         BoxShadow(
      //                   //           blurRadius: 0.5,
      //                   //           color: Colors.grey,
      //                   //           spreadRadius: 0.5,
      //                   //         ),
      //                   //       ],
      //                   //       borderRadius: BorderRadius.circular(10),
      //                   //     ),
      //                   //     child: Text(
      //                   //       'Request Service',
      //                   //       style: TextStyle(color: Colors.black),
      //                   //     ),
      //                   //   ),
      //                   // ),
      //                   // SizedBox(height: 20),

      //                   Expanded(
      //                     child: ListView.builder(
      //                       shrinkWrap: true,
      //                       itemCount: serviceProduct.data!.length,
      //                       itemBuilder: (context, index) {
      //                         return Column(
      //                           children: [
      //                             GestureDetector(
      //                               onTap: () {
      //                                 Helpers.productIndex = index;
      //                                 Navigator.of(context).pushNamed(
      //                                     'ServiceTrackerDetails',
      //                                     arguments: serviceProduct
      //                                     // arguments: {
      //                                     //   'productName':
      //                                     //       serviceProduct.data![index]
      //                                     //           ['product_group_description'],
      //                                     //   'productModel':
      //                                     //       serviceProduct.data![index]
      //                                     //           ['product_description'],
      //                                     //   'serialNo': serviceProduct
      //                                     //       .data![index]['serial_no'],
      //                                     //   'technician':
      //                                     //       serviceProduct.data![index]
      //                                     //           ['technician_service_group']

      //                                     //   // 'productName': serviceProduct
      //                                     //   //     .data![index]
      //                                     //   //     .productGroupDescription,
      //                                     //   // 'productModel': serviceProduct
      //                                     //   //     .data![index].productDescription!,
      //                                     //   // 'serialNo': serviceProduct
      //                                     //   //     .data![index].serialNo!,
      //                                     //   // 'technician': serviceProduct
      //                                     //   //     .data![index]
      //                                     //   //     .technicianServiceGroup
      //                                     // },
      //                                     );
      //                               },
      //                               child: Container(
      //                                 height: height * 0.1,
      //                                 decoration: BoxDecoration(
      //                                   border: Border.all(width: 0.1),
      //                                   color: Colors.white,
      //                                   boxShadow: [
      //                                     BoxShadow(
      //                                         blurRadius: 5,
      //                                         color: Colors.grey[200]!,
      //                                         offset: Offset(0, 10)),
      //                                   ],
      //                                   borderRadius:
      //                                       BorderRadius.circular(7.5),
      //                                 ),
      //                                 child: Row(
      //                                   children: [
      //                                     Expanded(
      //                                       flex: 15,
      //                                       child: Container(
      //                                         padding: EdgeInsets.symmetric(
      //                                           horizontal: 20,
      //                                           // vertical: 10,
      //                                         ),
      //                                         child: Column(
      //                                           mainAxisAlignment:
      //                                               MainAxisAlignment.center,
      //                                           crossAxisAlignment:
      //                                               CrossAxisAlignment.start,
      //                                           children: [
      //                                             Align(
      //                                               alignment:
      //                                                   Alignment.centerLeft,
      //                                               child: Text('null'),
      //                                               //   serviceProduct
      //                                               //       .data![index]
      //                                               //       .productDescription!,
      //                                               // ),
      //                                             ),
      //                                             SizedBox(height: 10),
      //                                             Align(
      //                                               alignment:
      //                                                   Alignment.centerRight,
      //                                               child: Text(
      //                                                 'Service Status : ${serviceProduct.data![index]['service_request_status']!}',
      //                                                 textAlign:
      //                                                     TextAlign.right,
      //                                               ),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     Expanded(
      //                                       child: Container(
      //                                         height: double.infinity,
      //                                         decoration: BoxDecoration(
      //                                           color: serviceProduct
      //                                                           .data![index][
      //                                                       'service_request_status'] ==
      //                                                   'Pending Collection'
      //                                               ? Colors.green
      //                                               : Colors.grey,
      //                                           borderRadius: BorderRadius.only(
      //                                             topRight: Radius.circular(10),
      //                                             bottomRight:
      //                                                 Radius.circular(10),
      //                                           ),
      //                                           boxShadow: [
      //                                             BoxShadow(
      //                                               blurRadius: 0.5,
      //                                               color: Colors.grey,
      //                                               spreadRadius: 0.5,
      //                                             ),
      //                                           ],
      //                                         ),
      //                                         child: Icon(Icons.chevron_right,
      //                                             color: Colors.white),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ),
      //                             SizedBox(height: 10),
      //                           ],
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //       );
      //     } else {
      //       // return Center(
      //       //   child: SpinKitFadingCircle(
      //       //     color: Colors.black,
      //       //     size: 30,
      //       //   ),
      //       // );
      //       return Center(
      //           child: Text('There is nothing to track',
      //               style: TextStyles.textDefault));
      //     }
      //     // return Container(
      //     //   margin: EdgeInsets.symmetric(
      //     //     horizontal: 15,
      //     //     vertical: 20,
      //     //   ),
      //     //   child: Column(
      //     //     children: [
      //     //       Align(
      //     //         alignment: Alignment.centerRight,
      //     //         child: Container(
      //     //           padding: EdgeInsets.symmetric(
      //     //             horizontal: 20,
      //     //             vertical: 5,
      //     //           ),
      //     //           decoration: BoxDecoration(
      //     //             color: Colors.white,
      //     //             boxShadow: [
      //     //               BoxShadow(
      //     //                 blurRadius: 0.5,
      //     //                 color: Colors.grey,
      //     //                 spreadRadius: 0.5,
      //     //               ),
      //     //             ],
      //     //             borderRadius: BorderRadius.circular(10),
      //     //           ),
      //     //           child: Text(
      //     //             'Request Service',
      //     //             style: TextStyle(color: Colors.black),
      //     //           ),
      //     //         ),
      //     //       ),
      //     //       SizedBox(height: 20),
      //     //       GestureDetector(
      //     //         onTap: () {
      //     //           Navigator.of(context).pushNamed('ServiceTrackerDetails');
      //     //         },
      //     //         child: Container(
      //     //           height: height * 0.1,
      //     //           decoration: BoxDecoration(
      //     //             border: Border.all(width: 0.1),
      //     //             color: Colors.white,
      //     //             boxShadow: [
      //     //               BoxShadow(
      //     //                   blurRadius: 5,
      //     //                   color: Colors.grey[200]!,
      //     //                   offset: Offset(0, 10)),
      //     //             ],
      //     //             borderRadius: BorderRadius.circular(7.5),
      //     //           ),
      //     //           child: Row(
      //     //             children: [
      //     //               Expanded(
      //     //                 flex: 6,
      //     //                 child: Container(
      //     //                   padding: EdgeInsets.symmetric(
      //     //                     horizontal: 20,
      //     //                     // vertical: 10,
      //     //                   ),
      //     //                   child: Column(
      //     //                     mainAxisAlignment: MainAxisAlignment.center,
      //     //                     crossAxisAlignment: CrossAxisAlignment.start,
      //     //                     children: [
      //     //                       Align(
      //     //                         alignment: Alignment.centerLeft,
      //     //                         child: Text(
      //     //                           'AC105I (1HP A.COND+IONIZER-I/D)',
      //     //                         ),
      //     //                       ),
      //     //                       SizedBox(height: 10),
      //     //                       Align(
      //     //                         alignment: Alignment.centerRight,
      //     //                         child: Text(
      //     //                           'Service Status : Receive',
      //     //                           textAlign: TextAlign.right,
      //     //                         ),
      //     //                       ),
      //     //                     ],
      //     //                   ),
      //     //                 ),
      //     //               ),
      //     //               Expanded(
      //     //                 child: Container(
      //     //                   height: double.infinity,
      //     //                   decoration: BoxDecoration(
      //     //                     color: Colors.green,
      //     //                     borderRadius: BorderRadius.only(
      //     //                       topRight: Radius.circular(10),
      //     //                       bottomRight: Radius.circular(10),
      //     //                     ),
      //     //                     boxShadow: [
      //     //                       BoxShadow(
      //     //                         blurRadius: 0.5,
      //     //                         color: Colors.grey,
      //     //                         spreadRadius: 0.5,
      //     //                       ),
      //     //                     ],
      //     //                   ),
      //     //                   child: Icon(Icons.chevron_right),
      //     //                 ),
      //     //               ),
      //     //             ],
      //     //           ),
      //     //         ),
      //     //       ),
      //     //       SizedBox(height: 10),
      //     //       Container(
      //     //         height: height * 0.1,
      //     //         decoration: BoxDecoration(
      //     //           border: Border.all(width: 0.1),
      //     //           color: Colors.white,
      //     //           boxShadow: [
      //     //             BoxShadow(
      //     //                 blurRadius: 5,
      //     //                 color: Colors.grey[200]!,
      //     //                 offset: Offset(0, 10)),
      //     //           ],
      //     //           borderRadius: BorderRadius.circular(7.5),
      //     //         ),
      //     //         child: Row(
      //     //           children: [
      //     //             Expanded(
      //     //               flex: 6,
      //     //               child: Container(
      //     //                 padding: EdgeInsets.symmetric(
      //     //                   horizontal: 20,
      //     //                   vertical: 10,
      //     //                 ),
      //     //                 child: Column(
      //     //                   mainAxisAlignment: MainAxisAlignment.center,
      //     //                   crossAxisAlignment: CrossAxisAlignment.start,
      //     //                   children: [
      //     //                     Align(
      //     //                       alignment: Alignment.centerLeft,
      //     //                       child: Text(
      //     //                         'AC105I (1HP A.COND+IONIZER-I/D)',
      //     //                       ),
      //     //                     ),
      //     //                     SizedBox(height: 10),
      //     //                     Align(
      //     //                       alignment: Alignment.centerRight,
      //     //                       child: Text(
      //     //                         'Service Status : Receive',
      //     //                         textAlign: TextAlign.right,
      //     //                       ),
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //               ),
      //     //             ),
      //     //             Expanded(
      //     //               child: Container(
      //     //                 height: double.infinity,
      //     //                 decoration: BoxDecoration(
      //     //                   color: Colors.grey,
      //     //                   borderRadius: BorderRadius.only(
      //     //                     topRight: Radius.circular(10),
      //     //                     bottomRight: Radius.circular(10),
      //     //                   ),
      //     //                   boxShadow: [
      //     //                     BoxShadow(
      //     //                       blurRadius: 0.5,
      //     //                       color: Colors.grey,
      //     //                       spreadRadius: 0.5,
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //                 child: Icon(Icons.chevron_right),
      //     //               ),
      //     //             ),
      //     //           ],
      //     //         ),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // );
      //   },
      // ),
      // body: Container(
      //   margin: EdgeInsets.symmetric(
      //     horizontal: 15,
      //     vertical: 20,
      //   ),
      //   child: Column(
      //     children: [
      //       Align(
      //         alignment: Alignment.centerRight,
      //         child: Container(
      //           padding: EdgeInsets.symmetric(
      //             horizontal: 20,
      //             vertical: 5,
      //           ),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             boxShadow: [
      //               BoxShadow(
      //                 blurRadius: 0.5,
      //                 color: Colors.grey,
      //                 spreadRadius: 0.5,
      //               ),
      //             ],
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: Text(
      //             'Request Service',
      //             style: TextStyle(color: Colors.black),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.of(context).pushNamed('ServiceTrackerDetails');
      //         },
      //         child: Container(
      //           height: height * 0.1,
      //           decoration: BoxDecoration(
      //             border: Border.all(width: 0.1),
      //             color: Colors.white,
      //             boxShadow: [
      //               BoxShadow(
      //                   blurRadius: 5,
      //                   color: Colors.grey[200]!,
      //                   offset: Offset(0, 10)),
      //             ],
      //             borderRadius: BorderRadius.circular(7.5),
      //           ),
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 flex: 6,
      //                 child: Container(
      //                   padding: EdgeInsets.symmetric(
      //                     horizontal: 20,
      //                     // vertical: 10,
      //                   ),
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Align(
      //                         alignment: Alignment.centerLeft,
      //                         child: Text(
      //                           'AC105I (1HP A.COND+IONIZER-I/D)',
      //                         ),
      //                       ),
      //                       SizedBox(height: 10),
      //                       Align(
      //                         alignment: Alignment.centerRight,
      //                         child: Text(
      //                           'Service Status : Receive',
      //                           textAlign: TextAlign.right,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Container(
      //                   height: double.infinity,
      //                   decoration: BoxDecoration(
      //                     color: Colors.green,
      //                     borderRadius: BorderRadius.only(
      //                       topRight: Radius.circular(10),
      //                       bottomRight: Radius.circular(10),
      //                     ),
      //                     boxShadow: [
      //                       BoxShadow(
      //                         blurRadius: 0.5,
      //                         color: Colors.grey,
      //                         spreadRadius: 0.5,
      //                       ),
      //                     ],
      //                   ),
      //                   child: Icon(Icons.chevron_right),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       Container(
      //         height: height * 0.1,
      //         decoration: BoxDecoration(
      //           border: Border.all(width: 0.1),
      //           color: Colors.white,
      //           boxShadow: [
      //             BoxShadow(
      //                 blurRadius: 5,
      //                 color: Colors.grey[200]!,
      //                 offset: Offset(0, 10)),
      //           ],
      //           borderRadius: BorderRadius.circular(7.5),
      //         ),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               flex: 6,
      //               child: Container(
      //                 padding: EdgeInsets.symmetric(
      //                   horizontal: 20,
      //                   vertical: 10,
      //                 ),
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Align(
      //                       alignment: Alignment.centerLeft,
      //                       child: Text(
      //                         'AC105I (1HP A.COND+IONIZER-I/D)',
      //                       ),
      //                     ),
      //                     SizedBox(height: 10),
      //                     Align(
      //                       alignment: Alignment.centerRight,
      //                       child: Text(
      //                         'Service Status : Receive',
      //                         textAlign: TextAlign.right,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //               child: Container(
      //                 height: double.infinity,
      //                 decoration: BoxDecoration(
      //                   color: Colors.grey,
      //                   borderRadius: BorderRadius.only(
      //                     topRight: Radius.circular(10),
      //                     bottomRight: Radius.circular(10),
      //                   ),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       blurRadius: 0.5,
      //                       color: Colors.grey,
      //                       spreadRadius: 0.5,
      //                     ),
      //                   ],
      //                 ),
      //                 child: Icon(Icons.chevron_right),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
