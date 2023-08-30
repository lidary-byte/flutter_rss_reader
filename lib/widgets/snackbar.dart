import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar({String? content}) {
  final context = Get.context;
  if (context == null) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content ?? ''),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'ok'.tr,
        onPressed: () {},
      ),
    ),
  );
}
