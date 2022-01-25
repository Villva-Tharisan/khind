import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/models/service_product.dart';
import 'package:khind/util/helpers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceTrackerDetails extends StatefulWidget {
  final ServiceProduct serviceProduct;

  const ServiceTrackerDetails({Key? key, required this.serviceProduct})
      : super(key: key);

  @override
  _ServiceTrackerDetailsState createState() => _ServiceTrackerDetailsState();
}

class _ServiceTrackerDetailsState extends State<ServiceTrackerDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late int index;

  @override
  void initState() {
    index = Helpers.productIndex!;
    super.initState();
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
                  Text('Status: '),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.serviceProduct.data![index]
                                  ['service_request_status'] ==
                              'Pending Collection'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    child: Text(
                      widget.serviceProduct.data![index]
                          ['service_request_status']!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.5,
                      color: Colors.grey,
                      spreadRadius: 0.5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.serviceProduct.data![index]
                        ['product_group_description']!),
                    Text(widget.serviceProduct.data![index]
                        ['product_description']!),
                    SizedBox(height: 15),
                    Text(
                        'Serial No: ${widget.serviceProduct.data![index]['serial_no'] ?? 'null'}'),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text('Drop Off'),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Text('XXXXXXXXX'),
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
                              'No. 2, Jalan Astaka U8/82, Bukit Jelutong, 40150 Shah Alam, Malaysia'),
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
                          child: Text(widget.serviceProduct.data![index]
                              ['technician_service_group']!),
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
                            padding: EdgeInsets.all(10),
                            height: 75,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                                widget.serviceProduct.data![index]['remarks']!),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
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
                  onPressed: () {},
                ),
              ),
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
              if (widget.serviceProduct.data![index]
                      ['service_request_status']! ==
                  'Pending Collection')
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
              if (widget.serviceProduct.data![index]
                      ['service_request_status']! !=
                  'Pending Collection')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      onPressed: () {},
                      child: Text(
                        'Survey',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
