import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Button extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final double? radius;
  final double? paddingHorizontal;
  final double? paddingVerticall;
  final Color? backgroundColor;
  const Button(
      {super.key,
      this.text,
      this.onTap,
      this.radius,
      this.paddingHorizontal,
      this.backgroundColor,
      this.paddingVerticall});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Get.theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 6), // 自定义圆角半径
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal ?? 16,
              vertical: paddingVerticall ?? 4),
          child: Text(text ?? '', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
