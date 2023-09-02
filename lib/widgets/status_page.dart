import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef ContentWidget<T> = Widget Function(T data);

// ignore: must_be_immutable
class StatusPage<T> extends StatelessWidget {
  final VoidCallback? onRetry;
  final PageStatusBean status;
  final ContentWidget<T> contentWidget;
  bool hasPadding;
  StatusPage(
      {super.key,
      required this.contentWidget,
      required this.status,
      this.onRetry,
      this.hasPadding = true});

  @override
  Widget build(BuildContext context) {
    return _statusWidget(context);
  }

  Widget _statusWidget(BuildContext context) {
    if (status is LoadingStatusBean) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(
              top: hasPadding
                  ? MediaQuery.of(context).size.height / 2 - 200
                  : 0),
          child: Platform.isAndroid
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator(radius: 18),
        ),
      );
    } else if (status is SuccessStatusBean) {
      final contentBean = status as SuccessStatusBean;
      return contentWidget.call(contentBean.data ?? []);
    } else if (status is ErrorStatusBean) {
      final errorBean = status as ErrorStatusBean;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorBean.errorMsg ?? 'loadingErrorTip'.tr),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: Text('retry'.tr))
        ],
      );
    }
    return const SizedBox();
  }
}

abstract class PageStatusBean {}

class LoadingStatusBean extends PageStatusBean {}

class SuccessStatusBean<T> extends PageStatusBean {
  T? data;
  SuccessStatusBean({this.data});
}

class ErrorStatusBean extends PageStatusBean {
  String? errorMsg;
  ErrorStatusBean({this.errorMsg});
}
