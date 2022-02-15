import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khind/components/custom_card.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/cubit/city/city_cubit.dart';
import 'package:khind/cubit/postcode/postcode_cubit.dart';
import 'package:khind/cubit/state/state_cubit.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/service_product.dart';
import 'package:khind/services/repositories.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceTrackerDelivery extends StatefulWidget {
  @override
  _ServiceTrackerDeliveryState createState() => _ServiceTrackerDeliveryState();
}

class _ServiceTrackerDeliveryState extends State<ServiceTrackerDelivery> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();

  late int index;
  late ServiceProduct serviceProduct;
  late ProductWarranty productWarranty;

  @override
  void initState() {
    index = Helpers.productIndex!;
    serviceProduct = Helpers.serviceProduct!;
    productWarranty = Helpers.productWarranty!;
    context.read<StateCubit>().getState();
    super.initState();
  }

  TextEditingController address1 = new TextEditingController();
  TextEditingController address2 = new TextEditingController();

  // List<String> state = [
  //   'state1',
  //   'state2',
  //   'state3',
  // ];
  List<String> city = [
    'city1',
    'city2',
    'city3',
  ];
  List<String> postcode = [
    'postcode1',
    'postcode2',
    'postcode3',
  ];

  String? chosenState;
  String? chosenCity;
  String? chosenPostcode;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: Helpers.customAppBar(
          context,
          _scaffoldKey,
          title: "Request For Delivery",
          hasActions: false,
          isBack: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey[200]!,
                        offset: Offset(0, 10)),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //model info
                    Text('Model Description'),
                    Text(
                      serviceProduct.data![index]['model_description']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Product Model'),
                    Text(
                      serviceProduct.data![index]['product_model']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    //form address
                    Text('Please Fill In Your Address'),
                    SizedBox(height: 15),
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address 1 : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: TextFormField(
                                  controller: address1,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    // border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address 2 : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: TextFormField(
                                  controller: address2,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    // border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: width * 0.25,
                                child: Text(
                                  'State : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 20),
                              BlocBuilder<StateCubit, StateState>(
                                builder: (context, state) {
                                  if (state is StateLoaded) {
                                    return Expanded(
                                      child: DropdownButton<String>(
                                        items: state.state.map((e) {
                                          return DropdownMenuItem(
                                            child: Text(e.state!),
                                            value: e.stateId,
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        value: chosenState,
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            chosenState = value!;
                                          });

                                          //reset city
                                          chosenCity = null;
                                          chosenPostcode = null;
                                          context
                                              .read<CityCubit>()
                                              .fetchCities(value!);
                                        },
                                      ),
                                    );
                                  } else {
                                    return SpinKitFadingCircle(
                                      color: Colors.black,
                                      size: 14,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          BlocBuilder<CityCubit, CityState>(
                            builder: (context, state) {
                              if (state is CityLoaded) {
                                return Row(
                                  children: [
                                    Container(
                                      width: width * 0.25,
                                      child: Text(
                                        'City : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        items: state.cities.map((e) {
                                          return DropdownMenuItem(
                                            child: Text(e.city!),
                                            value: e.cityId,
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        value: chosenCity,
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            chosenCity = value!;
                                          });

                                          String cityName = '';

                                          for (var i = 0;
                                              i < state.cities.length;
                                              i++) {
                                            if (state.cities[i].cityId ==
                                                value) {
                                              cityName = state.cities[i].city!;
                                            }
                                          }

                                          context
                                              .read<PostcodeCubit>()
                                              .getPostcode(
                                                  cityName, chosenState!);

                                          //reset
                                          chosenPostcode = null;
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else if (state is CityInitial) {
                                return Container();
                              } else {
                                return SpinKitFadingCircle(
                                  color: Colors.black,
                                  size: 14,
                                );
                              }
                            },
                          ),
                          BlocBuilder<PostcodeCubit, PostcodeState>(
                            builder: (context, state) {
                              if (state is PostcodeLoaded) {
                                return Row(
                                  children: [
                                    Container(
                                      width: width * 0.25,
                                      child: Text(
                                        'Postcode : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        items: state.postcode.map((e) {
                                          return DropdownMenuItem(
                                            child: Text(e.toString()),
                                            value: e.toString(),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        value: chosenPostcode,
                                        onChanged: (value) {
                                          // print(value);
                                          setState(() {
                                            chosenPostcode = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else if (state is PostcodeInitial) {
                                return Container();
                              } else {
                                return SpinKitFadingCircle(
                                  color: Colors.black,
                                  size: 14,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientButton(
                  height: 40,
                  child: Text(
                    "Request For Delivery",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.grey[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  onPressed: () async {
                    // Navigator.pushNamed(context, 'ServiceTrackerDelivery');
                    bool status = await Repositories.sendRequestforDelivery(
                        address1.text,
                        address2.text,
                        chosenCity!,
                        chosenPostcode!);

                    if (status) {
                      Alert(
                        context: context,
                        // type: AlertType.info,
                        title: "Request for delivery",
                        desc: "Request for delivery successful",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Okay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
