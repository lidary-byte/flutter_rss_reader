import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void dismissDialog() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}

void showLoadingDialog() {
  Get.dialog(LoadingWidget());
}

// ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  Color? backgroudColor;
  LoadingWidget({super.key, this.backgroudColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
            height: 100,
            width: 100,
            color: backgroudColor ?? Get.theme.colorScheme.onSurface,
            child: CupertinoActivityIndicator(
              color: Get.theme.colorScheme.primary,
              radius: 16,
            )),
      ),
    );
  }
}
