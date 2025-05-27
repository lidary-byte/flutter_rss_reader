import 'package:get/get.dart';

class HomeController extends GetxController {
  int _index = 0;
  int get index => _index;
  void changeIndex(int index) {
    if (index == _index) {
      return;
    }

    _index = index;
    update();
  }
}
