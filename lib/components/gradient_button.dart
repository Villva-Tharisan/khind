import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const GradientButton(
      {Key? key,
      required this.child,
      required this.gradient,
      this.width = double.infinity,
      this.height = 50.0,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 0.5),
              gradient: gradient,
              // boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.5), blurRadius: 1.5)]
            ),
            child: Material(
                color: Colors.transparent,
                child: Container(
                  child: child,
                ))));
  }
}
