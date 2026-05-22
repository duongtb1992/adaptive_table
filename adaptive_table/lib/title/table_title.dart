import 'package:flutter/Material.dart';

class TableTitle extends StatelessWidget {

  const TableTitle({super.key,
    required this.text,
    this.fontFamily = 'Unbounded',
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.color = const Color(0xff3D3D3D),
    this.height = 1.25,
  });

  final String text;
  final String fontFamily;
  final FontWeight fontWeight;
  final double? fontSize;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize ?? 20,
        color: color,
        height: height,
      ),
    );
  }

}