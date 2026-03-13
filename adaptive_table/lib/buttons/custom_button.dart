import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.borderColor,
    this.bgColor,
    this.label = 'Thêm',
    this.width,
    this.height,
    this.textColor,
    this.useShadow = true,
    this.widget,
    this.hPadding,
    this.vPadding,
  });

  final Function()? onPressed;
  final Color? borderColor;
  final Color? bgColor;
  final Color? textColor;
  final String label;
  final double? width;
  final double? height;
  final bool useShadow;
  final Widget? widget;
  final double? hPadding, vPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor ?? Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? bgColor ?? Colors.transparent),
        boxShadow: useShadow ? [
          BoxShadow(
            blurRadius: 3,
            offset: const Offset(1,1),
            color: Colors.black.withAlpha(30)
          )
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding ?? 12, vertical: vPadding ?? 4),
            child: Center(
              child: widget == null ? Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? const Color(0xff3d3d3d),
                ),
              ) : widget!,
            ),
          ),
        ),
      ),
    );
  }
}
