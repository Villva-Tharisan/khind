import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/util/helpers.dart';

class EwarrantyProductManual extends StatefulWidget {
  @override
  _EwarrantyProductManualState createState() => _EwarrantyProductManualState();
}

class _EwarrantyProductManualState extends State<EwarrantyProductManual> {
  int quantity = 0;
  String fileName = '';

  List<String> productGroup = [
    'Oven',
    'Fan',
    'Washing Machin',
  ];

  List<String> productModel = [
    'E000001',
    'E000002',
    'E000003',
  ];

  late String chosenProductGroup;
  late String chosenProductModel;

  @override
  void initState() {
    chosenProductGroup = productGroup[0];
    chosenProductModel = productModel[0];
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Helpers.customAppBar(
        context,
        _scaffoldKey,
        title: "E-Warranty",
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
                  Row(
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Text('Product Manual'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          items: productGroup
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
                              chosenProductGroup = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Text('Product Model'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          items: productModel
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
                          value: chosenProductModel,
                          onChanged: (value) {
                            setState(() {
                              chosenProductModel = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),

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
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 15,
                          ),
                        ),
                      ),

                      SizedBox(width: 7.5),
                      Text(quantity.toString()),
                      SizedBox(width: 7.5),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Warranty Period : '),
                      Text('12-12-2020 - 12-12-2021'),
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
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Text('Purchase Date '),
                      ),
                      Expanded(
                        child: Text('12-12-2020'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Text('Store '),
                      ),
                      Expanded(
                        child: Text('KHIND Marketing SDN BHD'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Text('Referrel Code '),
                      ),
                      Expanded(
                        child: Text('-'),
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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        PlatformFile file = result.files.first;

                        setState(() {
                          fileName = file.name;
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
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // color: Color(0xFFEFF0EF),
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Text('Upload File'),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(fileName),
                ],
              ),
            ),
            SizedBox(height: 15),
            Text('Please fill in the blanks fields'),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GradientButton(
                  height: 40,
                  child: Text(
                    "Apply",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.grey[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
