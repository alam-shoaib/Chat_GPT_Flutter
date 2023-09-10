import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    required this.lable,
    this.fontSize = 18,
    this.color,
    this.fontWeight,
    Key? key,
  }) : super(key: key);
  final String lable;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(lable,style: TextStyle(
      color: color?? Colors.white,
      fontSize: fontSize,
      fontWeight: fontWeight?? FontWeight.w500,
    ),);
  }
}
