import 'package:flutter/material.dart';

PopupMenuItem popupMenuWidget(
        {String? title, IconData? icon, VoidCallback? onTap}) =>
    PopupMenuItem(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title ?? ''), Icon(icon)],
      ),
    );
