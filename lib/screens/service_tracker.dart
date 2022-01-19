import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
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
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Helpers.customAppBar(
        context,
        _scaffoldKey,
        title: "Service Tracker",
        hasActions: false,
      ),
      body: FutureBuilder(
        future: Repositories.getServiceProduct(),
        builder: (context, snapshot) {
          // print("DATA: ${snapshot.data.runtimeType}");
          if (snapshot.hasData && snapshot.data != "[]") {
            ServiceProduct serviceProduct =
                ServiceProduct.fromJson(json.decode(snapshot.data.toString()));

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: serviceProduct.data!.length == 0
                  ? Center(
                      child: Text('There is nothing to track',
                          style: TextStyles.textSecondaryBold),
                    )
                  : Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 20,
                        //       vertical: 5,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           blurRadius: 0.5,
                        //           color: Colors.grey,
                        //           spreadRadius: 0.5,
                        //         ),
                        //       ],
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Text(
                        //       'Request Service',
                        //       style: TextStyle(color: Colors.black),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 20),

                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: serviceProduct.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        'ServiceTrackerDetails',
                                        arguments: {
                                          'productName': serviceProduct
                                              .data![index]
                                              .productGroupDescription,
                                          'productModel': serviceProduct
                                              .data![index].productDescription!,
                                          'serialNo': serviceProduct
                                              .data![index].serialNo!,
                                          'technician': serviceProduct
                                              .data![index]
                                              .technicianServiceGroup
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: height * 0.1,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.1),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 5,
                                              color: Colors.grey[200]!,
                                              offset: Offset(0, 10)),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(7.5),
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
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      serviceProduct
                                                          .data![index]
                                                          .productDescription!,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      'Service Status : Receive',
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
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
            // return Center(
            //   child: SpinKitFadingCircle(
            //     color: Colors.black,
            //     size: 30,
            //   ),
            // );
            return Center(
                child: Text('There is nothing to track',
                    style: TextStyles.textDefault));
          }
          // return Container(
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
          // );
        },
      ),
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
