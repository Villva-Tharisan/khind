import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';

class CustomCard extends StatelessWidget {
  final String? label;
  final double? width;
  final Color? color;
  final double? height;
  final TextStyle? textStyle;
  final double? borderRadius;
  final EdgeInsets? padding;

  const CustomCard(
      {Key? key,
      required this.label,
      this.color,
      this.width,
      this.height,
      this.textStyle,
      this.borderRadius,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width != null ? width : null,
        height: height != null ? height : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color != null ? color : Colors.grey,
            borderRadius:
                height != null ? BorderRadius.circular(height! / 2) : BorderRadius.circular(10)),
        padding: padding != null ? padding : const EdgeInsets.all(5),
        child: Text(label!, style: textStyle != null ? textStyle : TextStyles.textWhiteXs));
  }
}
