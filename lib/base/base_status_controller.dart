import 'package:flutter_rss_reader/widgets/status_page.dart';
import 'package:get/get.dart';

class BaseGetxController extends GetxController {
  PageStatusBean _pageStatusBean = LoadingStatusBean();
  PageStatusBean get pageStatusBean => _pageStatusBean;

  void updateLoadingStatus({List<Object> updateIds = const []}) {
    if (_pageStatusBean is! LoadingStatusBean) {
      _pageStatusBean = LoadingStatusBean();
      update(updateIds);
    }
  }

  void updateErrorStatus(String? errorMsg,
      {List<Object> updateIds = const []}) {
    if (_pageStatusBean is! ErrorStatusBean) {
      _pageStatusBean = ErrorStatusBean(errorMsg: errorMsg);
      update(updateIds);
    }
  }

  void updateSuccessStatus<T>(T data, {List<Object> updateIds = const []}) {
    if (_pageStatusBean is! SuccessStatusBean) {
      _pageStatusBean = SuccessStatusBean(data: data);
      update(updateIds);
    }
  }
}
