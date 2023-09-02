import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/widgets/status_page.dart';
import 'package:get/get.dart';

typedef ContentWidget<T> = Widget Function(T data);

// ignore: must_be_immutable
class SliverStatusPage<T> extends StatelessWidget {
  final VoidCallback? onRetry;
  final PageStatusBean status;
  final ContentWidget<T> contentWidget;
  bool hasPadding;
  SliverStatusPage(
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
      return SliverToBoxAdapter(
          child: Center(
        child: Padding(
          padding: EdgeInsets.only(
              top: hasPadding
                  ? MediaQuery.of(context).size.height / 2 - 200
                  : 0),
          child: Platform.isAndroid
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator(radius: 18),
        ),
      ));
    } else if (status is SuccessStatusBean) {
      final contentBean = status as SuccessStatusBean;
      return contentWidget.call(contentBean.data ?? []);
    } else if (status is ErrorStatusBean) {
      final errorBean = status as ErrorStatusBean;
      return SliverToBoxAdapter(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorBean.errorMsg ?? 'loadingErrorTip'.tr),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: Text('retry'.tr))
        ],
      ));
    }
    return const SizedBox();
  }
}
