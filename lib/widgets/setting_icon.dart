import 'package:flutter/material.dart';

class SettingIcon extends StatelessWidget {
  final String? imagePath;
  final Color? color;
  final IconData? icon;
  const SettingIcon({super.key, this.imagePath, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(6))),
      padding: EdgeInsets.all(imagePath == null ? 0 : 4),
      child: imagePath == null
          ? Icon(icon, color: Colors.white)
          : Image.asset(imagePath ?? '', fit: BoxFit.cover),
    );
  }
}
