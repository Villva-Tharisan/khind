import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';

class RoundButton extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyles;
  final Color? color;
  final double width;
  final double height;
  final Widget? child;
  final Function onPressed;
  final Border? customBorder;
  final BorderRadius? borderRadius;
  final IconData? icon;

  const RoundButton(
      {Key? key,
      required this.title,
      this.titleStyles,
      this.color,
      this.width = double.infinity,
      this.height = 40.0,
      this.customBorder,
      this.borderRadius,
      this.icon,
      this.child,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onPressed();
        },
        child: child != null
            ? child
            : Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color != null ? color : AppColors.primary,
                  borderRadius: borderRadius != null ? borderRadius : BorderRadius.circular(10),
                  border: customBorder != null
                      ? customBorder
                      : Border.all(color: Colors.grey[400]!, width: 0.5),
                ),
                child: Material(
                    color: Colors.transparent,
                    child: icon != null
                        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                              child: Text(title!,
                                  style: TextStyles.textW500.copyWith(color: Colors.white)),
                            ),
                            Icon(icon, color: Colors.white, size: 25),
                          ])
                        : Container(
                            child: Text(title!,
                                style: titleStyles != null
                                    ? titleStyles
                                    : TextStyles.textW500.copyWith(color: Colors.white)),
                          ))));
  }
}
