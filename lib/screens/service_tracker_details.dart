import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/util/helpers.dart';

class ServiceTrackerDetails extends StatefulWidget {
  const ServiceTrackerDetails({Key? key}) : super(key: key);

  @override
  _ServiceTrackerDetailsState createState() => _ServiceTrackerDetailsState();
}

class _ServiceTrackerDetailsState extends State<ServiceTrackerDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                    decoration: BoxDecoration(color: Colors.green),
                    child: Text(
                      'Collection',
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
                    Text('AIR COND'),
                    Text('AC105L (1HP A.COND_IONIZER-I/D)'),
                    SizedBox(height: 15),
                    Text('Serial No: A12GHY90'),
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
                          child: Text('Arif'),
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
                            child: Text('Fixed.'),
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
                    Text('Survey: Incomplete'),
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
