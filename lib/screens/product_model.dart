import 'package:flutter/material.dart';

class ProductModel extends StatefulWidget {
  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Model'),
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
              padding: EdgeInsets.all(15),
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
                  Text(
                    "AIR FRYER",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("ARF3000 AIR FRYER 3L BK KD"),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    "Warranty Period: 12-12-2020 - 12-12-2021",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
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
                  Text("Purchase Date: 10-12-2020"),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    "Store: Khind Marketing (M) SDN BHD",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // height: 2,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
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
                  Text("Fill in the product serial number"),
                  SizedBox(
                    height: 13,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          // controller: emailCT,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                              hintText: 'eg: AP550XXXXXMLKD',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(0))),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: FlatButton(
                      child: Text(
                        'Request Repair',
                        // style: TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.grey.withOpacity(0.3),
                      textColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(
                        'Request Repair',
                        // style: TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.grey.withOpacity(0.3),
                      textColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 128,
                    child: FlatButton(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      child: Text(
                        'I dont have this anymore',
                        textAlign: TextAlign.center,
                        // style: TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.grey.withOpacity(0.3),
                      textColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
