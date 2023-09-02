import 'package:get/get.dart';

class WebViewController extends GetxController {
  String _url = '';
  String get url => _url;

  String _title = '';
  String get title => _title;

  double _progress = 0;
  double get progress => _progress;
  @override
  void onInit() {
    _url = Get.arguments[parametersUrl];
    super.onInit();
  }

  void setTitle(String? title) {
    if (title == null || title.isBlank == true) {
      return;
    }
    _title = title;
    update(['app_bar']);
  }

  void setProgress(int progress) {
    _progress = progress / 100;
    update(['progress']);
  }

  static const String parametersUrl = 'url';
}
