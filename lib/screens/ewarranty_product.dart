import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EwarrantyProduct extends StatefulWidget {
  final Map arguments;

  const EwarrantyProduct({Key? key, required this.arguments}) : super(key: key);
  @override
  _EwarrantyProductState createState() => _EwarrantyProductState();
}

class _EwarrantyProductState extends State<EwarrantyProduct> {
  int quantity = 0;
  String fileName = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ewarranty'),
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
                  Text('AIR COND'),
                  Text(widget.arguments['productModel']),
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Save'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
