import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void showLoadingDialog({String title = '加载中'}) {
  Get.dialog(LoadingWidget(loadingTitle: title));
}

// ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  String loadingTitle;
  LoadingWidget({super.key, required this.loadingTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
            height: 100,
            width: 100,
            color: Get.theme.colorScheme.onSurface,
            child: CupertinoActivityIndicator(
              color: Get.theme.colorScheme.surface,
              radius: 16,
            )),
      ),
    );
  }
}
