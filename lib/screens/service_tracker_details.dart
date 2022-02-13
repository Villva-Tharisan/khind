import 'package:flutter/material.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/service_product.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceTrackerDetails extends StatefulWidget {
  @override
  _ServiceTrackerDetailsState createState() => _ServiceTrackerDetailsState();
}

class _ServiceTrackerDetailsState extends State<ServiceTrackerDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late int index;
  late ServiceProduct serviceProduct;
  late ProductWarranty productWarranty;

  @override
  void initState() {
    index = Helpers.productIndex!;
    serviceProduct = Helpers.serviceProduct!;
    productWarranty = Helpers.productWarranty!;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: Helpers.customAppBar(
        context,
        _scaffoldKey,
        title: "Product Name",
        hasActions: false,
        isBack: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Container()),
                  Text('Status :'),
                  SizedBox(width: 5),
                  CustomCard(
                      color: getColor(serviceProduct.data![index]['service_request_status']!),
                      borderRadius: BorderRadius.circular(5),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      textStyle: TextStyles.textWhiteSm,
                      label: serviceProduct.data![index]['service_request_status']!),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: serviceProduct.data![index]['service_request_status'] ==
                  //             'Pending Collection'
                  //         ? Colors.green
                  //         : Colors.grey[300],
                  //   ),
                  //   child: Text(
                  //     serviceProduct.data![index]['service_request_status']!,
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  SizedBox(width: 20),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     blurRadius: 0.5,
                  //     color: Colors.grey,
                  //     spreadRadius: 0.5,
                  //   ),
                  // ],
                  border: Border.all(
                    width: 0.4,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productWarranty.data![0].productGroupDescription!,
                        style: TextStyles.textDefaultBold),
                    Text(productWarranty.data![0].productDescription!,
                        style: TextStyles.textDefaultBold),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text('Serial No.'),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Text(serviceProduct.data![index]['serial_no']!),
                        )
                      ],
                    ),
                    // Text('Serial No: ${serviceProduct.data![index]['serial_no']}'),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text('Service Type'),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Text(serviceProduct.data![index]['service_type']!),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text('Location'),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Text(
                              '${serviceProduct.data![index]['street']!}, ${serviceProduct.data![index]['address_2']!}'),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text('Technician'),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Text(productWarranty.data![0].technicianServiceGroup!),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text('Remarks'),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 75,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(serviceProduct.data![index]['remarks'] ?? 'null'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              if (serviceProduct.data![index]['service_request_status']! == 'Pending Collection' ||
                  serviceProduct.data![index]['service_request_status']! == 'Collected')
                //     'Collected')

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GradientButton(
                    height: 40,
                    child: Text(
                      "View Invoice",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.grey[400]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    onPressed: () => Navigator.pushNamed(context, 'invoice'),
                  ),
                ),

              if (serviceProduct.data![index]['service_request_status']! == 'Collected')
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Survey: Incomplete'),
                          SizedBox(height: 20),
                          Text(
                            '* Give us feedback by participating in the Survey. You may view your result after completion of the survey',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GradientButton(
                        height: 40,
                        child: Text(
                          "Survey",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        gradient: LinearGradient(
                            colors: <Color>[Colors.white, Colors.grey[400]!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        onPressed: () {
                          Alert(
                            // style: AlertStyle(),
                            onWillPopActive: false,
                            context: context,
                            // type: AlertType.info,
                            title: 'Choose Language',
                            desc: 'Choose a language for survey',
                            buttons: [
                              DialogButton(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  launch(Uri.encodeFull(
                                      'https://surveyheart.com/form/60d5450b4297ae51da66832a'));
                                },
                                color: Colors.green,
                                radius: BorderRadius.circular(10),
                              ),
                              DialogButton(
                                child: Text(
                                  'Bahasa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  launch(Uri.encodeFull(
                                      'https://surveyheart.com/form/60da84673edbbc27c2c0cccb'));
                                },
                                color: Colors.red,
                                radius: BorderRadius.circular(10),
                              ),
                            ],
                          ).show();
                        },
                      ),
                    ),
                  ],
                ),
              // if (serviceProduct.data![index]['service_request_status']! !=
              //     'Collected')
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20),
              //     child: SizedBox(
              //       width: double.infinity,
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(primary: Colors.grey),
              //         onPressed: () {},
              //         child: Text(
              //           'Survey',
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
