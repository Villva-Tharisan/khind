import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ServiceTracker extends StatelessWidget {
  const ServiceTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('List of Items to Track'),
      ),
    );
  }
}
